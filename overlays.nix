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
        #kdePackages = master-pkgs.kdePackages;
        #services.desktopManager.plasma6 = master-pkgs.services.desktopManager.plasma6;
        #services.displayManager.plasma-login-manager = master-pkgs.services.desktopManager.plasma6;

        # Use fix from master for v4l2loopback. This module is used by obs studio.
        # https://github.com/NixOS/nixpkgs/issues/575851
        linuxPackages_latest = prev.linuxPackages_latest.extend (
          _: _: {
            v4l2loopback = master-pkgs.linuxPackages_latest.v4l2loopback;
          }
        );
      }
    )
  ];
}
