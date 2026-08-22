-- Runtime cargo-feature switching for rust-analyzer.
--
-- rust-analyzer *pulls* its configuration: after a workspace/didChangeConfiguration
-- notification it re-issues workspace/configuration for section "rust-analyzer",
-- which neovim answers out of client.settings. So retargeting the active feature
-- set is just: rebuild client.settings["rust-analyzer"], then notify.
do
  local SERVER = "rust_analyzer"
  local SECTION = "rust-analyzer"

  -- nil = fall back to the nix-defined baseline, "all" = --all-features,
  -- or a list of feature names. Session-only, not persisted.
  local state = { features = nil }

  -- Feature names discovered per project root, cached for the session.
  local cache = {}

  ---------------------------------------------------------------------------
  -- baseline
  ---------------------------------------------------------------------------

  -- Read the settings nixvim generated into vim.lsp.config lazily, so this file
  -- does not depend on running after nixvim's LSP block.
  local baseline
  local function base()
    if not baseline then
      local ok, cfg = pcall(function()
        return vim.lsp.config[SERVER]
      end)
      local settings = ok and cfg and cfg.settings or nil
      baseline = vim.deepcopy(settings and settings[SECTION] or {})
    end
    return baseline
  end

  ---------------------------------------------------------------------------
  -- applying
  ---------------------------------------------------------------------------

  local function describe(features)
    if features == nil then
      return "default (from nix)"
    elseif features == "all" then
      return "all"
    elseif #features == 0 then
      return "none"
    end
    return table.concat(features, ", ")
  end

  local function clients()
    return vim.lsp.get_clients({ name = SERVER })
  end

  local function build()
    local ra = vim.deepcopy(base())
    if state.features ~= nil then
      ra.cargo = ra.cargo or {}
      ra.cargo.features = state.features
    end
    return ra
  end

  local function restart()
    for _, client in ipairs(clients()) do
      client:stop(true)
    end
    vim.defer_fn(function()
      vim.lsp.enable(SERVER, false)
      vim.lsp.enable(SERVER)
      -- Re-trigger attachment for already-open rust buffers.
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "rust" then
          vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
        end
      end
    end, 200)
  end

  local function apply(features, bang)
    state.features = features
    local ra = build()

    -- Future clients inherit the choice. Use the assignment form, which replaces
    -- rather than deep-merges: the call form cannot remove a key, so `default`
    -- would otherwise leave a stale cargo.features behind.
    local cfg = vim.lsp.config[SERVER] or {}
    cfg.settings = vim.deepcopy(cfg.settings or {})
    cfg.settings[SECTION] = ra
    vim.lsp.config[SERVER] = cfg

    local attached = clients()
    for _, client in ipairs(attached) do
      client.settings = client.settings or {}
      client.settings[SECTION] = ra
      if not bang then
        client:notify("workspace/didChangeConfiguration", { settings = client.settings })
      end
    end

    if bang and #attached > 0 then
      restart()
    end

    local how = bang and " (restarting)" or (#attached == 0 and " (no client attached yet)" or "")
    vim.notify("rust-analyzer: features = " .. describe(features) .. how)
  end

  ---------------------------------------------------------------------------
  -- feature discovery
  ---------------------------------------------------------------------------

  local function root()
    local found = vim.fs.find({ "Cargo.toml" }, {
      upward = true,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })[1]
    if found then
      return vim.fs.dirname(found), found
    end
    return vim.uv.cwd(), nil
  end

  local function sorted_keys(set)
    local out = {}
    for k in pairs(set) do
      table.insert(out, k)
    end
    table.sort(out)
    return out
  end

  -- Fallback for when cargo is absent (it lives in a per-project devshell here):
  -- scan the nearest Cargo.toml's [features] table by hand.
  local function scan_manifest(manifest)
    if not manifest then
      return {}
    end
    local ok, lines = pcall(vim.fn.readfile, manifest)
    if not ok then
      return {}
    end
    local set, inside = {}, false
    for _, line in ipairs(lines) do
      if line:match("^%s*%[") then
        inside = line:match("^%s*%[features%]") ~= nil
      elseif inside then
        local name = line:match("^%s*([%w_%-]+)%s*=")
        if name then
          set[name] = true
        end
      end
    end
    return sorted_keys(set)
  end

  -- Authoritative source when a devshell provides cargo: covers every workspace
  -- member. Run async so a cold `cargo metadata` can never block the UI.
  local function refresh_from_cargo(dir)
    if vim.fn.executable("cargo") ~= 1 then
      return
    end
    vim.system(
      { "cargo", "metadata", "--no-deps", "--format-version", "1" },
      { cwd = dir, text = true },
      function(res)
        if res.code ~= 0 or not res.stdout or res.stdout == "" then
          return
        end
        local ok, meta = pcall(vim.json.decode, res.stdout)
        if not ok or type(meta) ~= "table" or type(meta.packages) ~= "table" then
          return
        end
        local set = {}
        for _, pkg in ipairs(meta.packages) do
          for name in pairs(pkg.features or {}) do
            set[name] = true
          end
        end
        cache[dir] = sorted_keys(set)
      end
    )
  end

  local function features_for_project()
    local dir, manifest = root()
    if cache[dir] then
      -- Kick off a refresh in the background but answer from cache now.
      return cache[dir]
    end
    refresh_from_cargo(dir)
    local scanned = scan_manifest(manifest)
    cache[dir] = scanned
    return scanned
  end

  ---------------------------------------------------------------------------
  -- command
  ---------------------------------------------------------------------------

  local KEYWORDS = { "all", "none", "default", "status" }

  local function parse(args)
    -- Accept both `:RustFeatures ssr serde` and `:RustFeatures ssr,serde`.
    local out = {}
    for _, arg in ipairs(args) do
      for piece in tostring(arg):gmatch("[^,%s]+") do
        table.insert(out, piece)
      end
    end
    return out
  end

  local function pick(bang)
    local items = { "default", "all", "none" }
    local seen = { default = true, all = true, none = true }
    for _, name in ipairs(features_for_project()) do
      if not seen[name] then
        seen[name] = true
        table.insert(items, name)
      end
    end
    vim.ui.select(items, {
      prompt = "rust-analyzer cargo features (current: " .. describe(state.features) .. ")",
    }, function(choice)
      if not choice then
        return
      end
      if choice == "default" then
        apply(nil, bang)
      elseif choice == "all" then
        apply("all", bang)
      elseif choice == "none" then
        apply({}, bang)
      else
        apply({ choice }, bang)
      end
    end)
  end

  vim.api.nvim_create_user_command("RustFeatures", function(opts)
    local args = parse(opts.fargs)

    if #args == 0 then
      pick(opts.bang)
      return
    end

    if #args == 1 then
      local one = args[1]
      if one == "status" then
        vim.notify("rust-analyzer: features = " .. describe(state.features))
        return
      elseif one == "default" then
        apply(nil, opts.bang)
        return
      elseif one == "all" then
        apply("all", opts.bang)
        return
      elseif one == "none" then
        apply({}, opts.bang)
        return
      end
    end

    apply(args, opts.bang)
  end, {
    nargs = "*",
    bang = true,
    desc = "Switch rust-analyzer's active cargo feature set",
    complete = function(lead)
      local out, seen = {}, {}
      local function add(name)
        if not seen[name] and name:find(lead, 1, true) == 1 then
          seen[name] = true
          table.insert(out, name)
        end
      end
      for _, name in ipairs(KEYWORDS) do
        add(name)
      end
      for _, name in ipairs(features_for_project()) do
        add(name)
      end
      return out
    end,
  })
end
