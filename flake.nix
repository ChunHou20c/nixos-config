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
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, lanzaboote, ... }@inputs: {

    nixosConfigurations = {

      lenovo-ideapad-slim-5i = let

        username = "chunhou";
        specialArgs = { inherit username; };

      in nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        inherit specialArgs;
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
