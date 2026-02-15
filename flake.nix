{
  description = "NixOS flake configuration by ChunHou20c";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    # nix com    extra-substituters = [munity's cache server
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # NixOS official package source, using the nixos-25.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cursor.url = "github:omarcresp/cursor-flake/main";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, lanzaboote, nixpkgs-unstable, cursor, ... }@inputs: {

    nixosConfigurations = {

      lenovo-ideapad-slim-5i = let


        system = "x86_64-linux";
        username = "chunhou";
        specialArgs = { inherit username; };
	pkgs-unstable = (import nixpkgs-unstable { config.allowUnfree = true; inherit system; });

      in nixpkgs.lib.nixosSystem {

        inherit system;
	specialArgs = {
	  inherit pkgs-unstable;
	  inherit username;
	};
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./hosts/lenovo-ideapad-slim-5i
          ./users/${username}/nixos.nix
          ./dev-tools
          lanzaboote.nixosModules.lanzaboote

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} =
              import ./users/${username}/home.nix;
          }
	  {
	    environment.systemPackages = [ cursor.packages.${pkgs-unstable.system}.default ];
	  }

        ];
      };

      acer-aspire-e14 = let

        username = "chunhou";
        specialArgs = { inherit username; };

      in nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./hosts/acer-aspire-e14
          ./users/${username}/nixos.nix
          # ./dev-tools
          # lanzaboote.nixosModules.lanzaboote

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} =
              import ./users/${username}/home.nix;
          }

        ];
      };

      minimal = let

        username = "chunhou";
        specialArgs = { inherit username; };

      in nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        inherit specialArgs;
        modules = [

          ./configuration-minimal.nix

        ];
      };
    };
  };
}
