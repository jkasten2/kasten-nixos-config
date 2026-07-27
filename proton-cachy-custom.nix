final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    {
      version = "11.0-20260602";
      sha256 = "sha256-SVJSIqd7SEjtl2FcsCHOUgYYSDMn3cedA2GTGUNmDQM=";
    }
    {
      version = "11.0-20260703";
      sha256 = "sha256-8Y7orUvnFOG0zSqCrMyvmclmy3JInj7d8A2h0Y7RwhE=";
    }
  ];
  genZipUrl =
    v:
    "https://github.com/CachyOS/proton-cachyos/releases/download/${v}-slr/proton-${v}-slr-x86_64_v3.tar.xz";
  overrideProtonVersion =
    { version, sha256 }:
    let
      displayName = "cachyos-${version}";
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
