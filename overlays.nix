{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        master-pkgs = import inputs.nixpkgs-master {
          system = prev.system;
        };
      in
      {
        kdePackages = master-pkgs.kdePackages;
        services.desktopManager.plasma6 = master-pkgs.services.desktopManager.plasma6;
        services.displayManager.plasma-login-manager = master-pkgs.services.desktopManager.plasma6;
      }
    )
  ];
}
