{
  symlinkJoin,
  replaceVarsWith,
  bash,
  coreutils,
  parallel,
  gawk,
  gnugrep,
  jq,
  iproute2,
  util-linux,
  lib,
}: let
  mkScript = name: {
    src ? ./${name}.sh,
    replacements ? {},
  }:
    replaceVarsWith {
      inherit name src replacements;
      dir = "bin";
      isExecutable = true;
    };
  scripts = lib.mapAttrs mkScript {
    ips.replacements = {
      inherit
        bash
        iproute2
        util-linux
        gawk
        ;
    };
    pkgs.replacements = {
      inherit
        bash
        coreutils
        parallel
        gawk
        gnugrep
        jq
        ;
    };
  };
in
  symlinkJoin (_finalAttrs: {
    name = "cutstom-scripts";
    paths = lib.attrValues scripts;
    passthru.scripts = scripts;
  })
