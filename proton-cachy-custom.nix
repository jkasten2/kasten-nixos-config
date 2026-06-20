final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    {
      version = "11.0-20260602";
      sha256 = "sha256-SVJSIqd7SEjtl2FcsCHOUgYYSDMn3cedA2GTGUNmDQM=";
    }
  ];
  genZipUrl =
    v:
    "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${v}-slr/proton-cachyos-${v}-slr-x86_64_v3.tar.xz";
  overrideProtonVersion =
    { version, sha256 }:
    let
      displayName = "proton-cachyos-${version}-slr-x86_64_v3";
      pname = "proton-cachyos-${version}-bin";
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
