final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    { version = "10-20"; sha256 = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg="; }
    { version = "10-19"; sha256 = "sha256-vV009ZlYFEAI1jkfMql46QnJXekRup5TqajVSc57f3U="; }
    { version = "10-18"; sha256 = "sha256-s2xnoyRy4JI1weRJ+9wjZzBRpsH7HMbK9DbhdVDJKww="; }
    { version = "10-17"; sha256 = "sha256-GMwAAKuaBhDv1TvAuW9DVcXSYPRM87NP6NnJfk8O8ZU="; }
  ];
  genZipUrl = v:
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/" +
    "${v}/${v}.tar.gz";
  overrideProtonVersion = { version, sha256 }: let
    displayName = "GE-Proton${version}";
    pname = "proton-ge-${version}-bin";
  in {
    ${pname} = (
      packageToOverride.override { steamDisplayName = displayName; }
    ).overrideAttrs {
      pname = pname;
      version = displayName;
      src = prev.fetchzip { url = genZipUrl displayName; sha256 = sha256; };
    };
  };
in
builtins.foldl'(acc: item: overrideProtonVersion(item) // acc) {} versionList

