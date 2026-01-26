final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    {
      version = "10-20";
      sha256 = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    }
    {
      version = "10-28";
      sha256 = "sha256-6NvSGX8445la6WU6z9UaaKJm30eg094cuTyhHVDjbOo=";
    }
  ];
  genZipUrl =
    v: "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/" + "${v}/${v}.tar.gz";
  overrideProtonVersion =
    { version, sha256 }:
    let
      displayName = "GE-Proton${version}";
      pname = "proton-ge-${version}-bin";
    in
    {
      ${pname} = (packageToOverride.override { steamDisplayName = displayName; }).overrideAttrs {
        pname = pname;
        version = displayName;
        src = prev.fetchzip {
          url = genZipUrl displayName;
          sha256 = sha256;
        };
      };
    };
in
builtins.foldl' (acc: item: overrideProtonVersion (item) // acc) { } versionList
