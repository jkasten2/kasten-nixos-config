{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: try home-manager later
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."KastenNixOS7700x" = 
      let system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      inherit system;
      modules = [
        ./configuration.nix
        # inputs.home-manager.nixosModules.default


        ({pkgs, config, ... }: {
	config = {
          nix.settings = {
            # add binary caches
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://nixpkgs-wayland.cachix.org"
            ];
          };

          # use it as an overlay
          nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
        };
        })
      ];
    };
  };
}

