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
    nixosConfigurations."KastenNixOS7700x" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlays.default ];
        })
        # inputs.home-manager.nixosModules.default

      ];
    };
  };
}

