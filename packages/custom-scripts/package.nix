{
  symlinkJoin,
  replaceVarsWith,
  runtimeShell,
  git,
  opencode,
  nixfmt,
  yq-go,
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
    "2nix".replacements = {
      inherit
        runtimeShell
        nixfmt
        yq-go
        ;
    };
    ai-commit.replacements = {
      inherit
        runtimeShell
        git
        opencode
        ;
    };
    ips.replacements = {
      inherit
        runtimeShell
        iproute2
        util-linux
        gawk
        ;
    };
    pkgs.replacements = {
      inherit
        runtimeShell
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
