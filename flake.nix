{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Is there a better way to force follow all flake-util and systems
    #       usages to keep the .lock file cleaner?
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lib-aggregate.inputs.flake-utils.follows = "flake-utils";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nuschtosSearch.inputs.flake-utils.follows = "flake-utils";
      inputs.systems.follows = "flake-utils/systems";
    };

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "flake-utils/systems";
    };
    walker = {
      url = "github:abenz1267/walker";
      # TODO: Probabaly something this package should handle for us?
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "elephant/nixpkgs";
      inputs.systems.follows = "elephant/systems";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, ... }@inputs: {
    nixosConfigurations."KastenNixOS7700x" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        lanzaboote.nixosModules.lanzaboote
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            inputs.nixpkgs-wayland.overlays.default
            (import ./gamescope.nix)
            (import ./proton-ge-custom.nix)
          ];
        })
      ];

    };
  };
}

