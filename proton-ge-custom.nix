final: prev:

let
  packageToOverride = prev.proton-ge-bin;
  versionList = [
    {
      version = "10-20";
      sha256 = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    }
    {
      version = "10-30";
      sha256 = "sha256-YZ+v+dzO70qTs3JxOAk9n7ByIYb3r8SeJBWnzjKQwuQ=";
    }
    {
      version = "10-32";
      sha256 = "sha256-NxZ4OJUYQdRNQTb62jRET6Ef14LEhynOASIMPvwWeNA=";
    }
    {
      version = "10-34";
      sha256 = "sha256-lzPsYYcrp5NoT3B0WFj3o10Z7tXx7xva1wEP3edeuqM=";
    }
  ];
  genZipUrl =
    v: "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${v}/${v}.tar.gz";
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
