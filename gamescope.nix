# Usage: Add to overlays array in home.nix
final: prev: {
              gamescope = prev.gamescope.overrideAttrs(old: {
                src = prev.fetchFromGitHub {
                  owner = "ValveSoftware";
                  repo = "gamescope";
                  # Contains fix for newer wayland, fixes error:
                  #   error 0: get_windows_scrgb is not supported
                  # https://github.com/ValveSoftware/gamescope/issues/1825
                  rev = "0d3a19791de447a673e315a5aed3f59ad64ebb71";
                  fetchSubmodules = true;
                  hash = "sha256-AT66/QMzvTHCe/j/ju2c8hKjjOGGew1gux8sgiVhl/8=";
                };
              });
}
