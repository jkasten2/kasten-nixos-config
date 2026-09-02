final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    {
      version = "10-20";
      arch = "";
      sha256 = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    }
    {
      version = "10-34";
      arch = "";
      sha256 = "sha256-lzPsYYcrp5NoT3B0WFj3o10Z7tXx7xva1wEP3edeuqM=";
    }
    {
      version = "11-3";
      arch = "";
      sha256 = "sha256-RiCmnUKeZRhPUCgm7fsROKFkAl37+/tYkA47tQtkIF4=";
    }
    {
      version = "11-6";
      arch = "-x86_64";
      sha256 = "sha256-rX27DUrrrHtR1cgyr/424m9JPjrdASIisVGv2vWzMAs=";
    }
  ];
  genZipUrl =
    v: arch:
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${v}/${v}${arch}.tar.gz";
  overrideProtonVersion =
    {
      version,
      arch,
      sha256,
    }:
    let
      displayName = "GE-Proton${version}";
      pname = "proton-ge-${version}-bin";
    in
    {
      ${pname} = (packageToOverride.override { steamDisplayName = displayName; }).overrideAttrs {
        pname = pname;
        version = displayName;
        src = prev.fetchzip {
          url = genZipUrl displayName arch;
          sha256 = sha256;
        };
      };
    };
in
builtins.foldl' (acc: item: overrideProtonVersion (item) // acc) { } versionList
