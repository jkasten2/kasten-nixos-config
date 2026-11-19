{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        master-pkgs = import inputs.nixpkgs-master {
          localSystem = final.stdenv.hostPlatform;
        };
      in
      {
        mesa = master-pkgs.mesa;
        linuxPackages_latest = master-pkgs.linuxPackages_latest;
        #kdePackages = master-pkgs.kdePackages;
        #services.desktopManager.plasma6 = master-pkgs.services.desktopManager.plasma6;
        #services.displayManager.plasma-login-manager = master-pkgs.services.desktopManager.plasma6;
      }
    )
  ];
}
