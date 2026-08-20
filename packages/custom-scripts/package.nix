{
  symlinkJoin,
  replaceVarsWith,
  makeDesktopItem,
  copyDesktopItems,
  callPackage,
  lib,
}: let
  getVars = lib.flip lib.pipe [
    builtins.readFile
    (builtins.split "@([a-zA-Z_][0-9A-Za-z_'-]*)@")
    (builtins.filter builtins.isList)
    (map builtins.head)
    lib.unique
  ];
  mkScript = script: let
    fn =
      if lib.isFunction script
      then script
      else let
        attrs =
          if lib.isPath script
          then {src = script;}
          else script;
        vars = getVars attrs.src;
      in
        lib.setFunctionArgs
        (replacements: attrs // {inherit replacements;})
        (lib.genAttrs vars (_: false));
  in
    callPackage (lib.mirrorFunctionArgs fn (
      args: let
        attrs = fn args;
        name = baseNameOf attrs.src;
        ext = lib.last (lib.splitString "." name);
      in
        replaceVarsWith (
          {
            name = lib.removeSuffix ".${ext}" name;
          }
          // attrs
          // {
            dir = "bin";
            isExecutable = true;
          }
        )
    )) {};
in
  symlinkJoin (finalAttrs: {
    name = "cutstom-scripts";
    paths = lib.map mkScript [
      ./scripts/2nix.sh
      ./scripts/ai-commit.sh
      ./scripts/ips.sh
      ./scripts/nstore.sh
      ./scripts/pkgs.sh
      ./scripts/qrscan.sh
      {
        src = ./scripts/scrcpy-finder.sh;
        desktopItems = [
          (makeDesktopItem {
            name = "scrcpy-finder";
            exec = "scrcpy-finder";
            desktopName = "Scrcpy Finder";
          })
        ];
        nativeBuildInputs = [
          copyDesktopItems
        ];
      }
    ];
  })
