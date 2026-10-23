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

        # Work around for build failure on package v4l2loopback. This module is used by obs studio.
        # https://github.com/NixOS/nixpkgs/issues/575851
        linuxPackages_latest = prev.linuxPackages_latest.extend (
          _: lp: {
            v4l2loopback = lp.v4l2loopback.overrideAttrs (o: {
              installFlags = (o.installFlags or [ ]) ++ [ "DEPMOD=true" ];
            });
          }
        );
      }
    )
  ];
}
