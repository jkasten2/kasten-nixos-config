{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
      # TODO: Got to be a better way to chain follows
      inputs.systems.follows = "nixpkgs-wayland/lib-aggregate/flake-utils/systems";
    };
    walker = {
      url = "github:abenz1267/walker";
      # TODO: Probabaly something this package should handle for us?
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "elephant/nixpkgs";
      inputs.systems.follows = "elephant/systems";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."KastenNixOS7700x" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            inputs.nixpkgs-wayland.overlays.default
            (import ./gamescope.nix)
          ];
        })
      ];

    };
  };
}

