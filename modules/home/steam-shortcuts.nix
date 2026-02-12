{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.steam-shortcuts;

  steamConfDirRelative =
    if pkgs.stdenv.hostPlatform.isDarwin then "Library/Application Support/Steam" else ".steam/steam";

  json2vdf =
    name: value:
    pkgs.runCommand name
      {
        value = builtins.toJSON value;
        passAsFile = [ "value" ];

        buildCommandPython =
          pkgs.writers.writePython3 "json2vdf.py"
            {
              libraries = [ pkgs.python3Packages.vdf ];
              doCheck = false;
            }
            ''
              import json
              import sys
              import vdf

              def json2vdf(data):
                if isinstance(data, dict):
                  return {k: json2vdf(v) for k, v in data.items()}
                if isinstance(data, list):
                  return {str(k): json2vdf(v) for k, v in enumerate(data)}
                else:
                  return data

              with open(sys.argv[1]) as fp:
                data = json.load(fp)

              data = json2vdf(data)

              with open(sys.argv[2], "wb") as fp:
                vdf.binary_dump(data, fp)
            '';
      }
      ''
        "$buildCommandPython" "$valuePath" "$out"
      '';
in
{
  options.services.steam-shortcuts = {
    enable = lib.mkEnableOption "Steam shortcuts management";

    steamUserId = lib.mkOption {
      type = lib.types.int;
    };

    steamHomeDir = lib.mkOption {
      type = lib.types.str;
      default = config.home.homeDirectory;
    };

    userConfigDir = lib.mkOption {
      type = lib.types.str;
      internal = true;
      default = "${cfg.steamHomeDir}/${steamConfDirRelative}/userdata/${builtins.toString cfg.steamUserId}/config";
    };

    shortcutsPath = lib.mkOption {
      type = lib.types.str;
      internal = true;
      default = "${cfg.userConfigDir}/shortcuts.vdf";
    };

    shortcuts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            freeformType = lib.types.attrsOf lib.types.anything;
            options = {
              appname = lib.mkOption {
                type = lib.types.str;
                default = name;
              };
              appid = lib.mkOption {
                type = lib.types.int;
                default =
                  -1
                  - (builtins.bitAnd 2147483647 (
                    lib.trivial.fromHexString (builtins.substring 0 8 (builtins.hashString "sha256" name))
                  ));
              };
              exe = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file."${cfg.shortcutsPath}" = {
      source = json2vdf "shortcuts.vdf" {
        shortcuts = lib.mapAttrsToList (
          _: lib.attrsets.filterAttrs (_: value: value != null)
        ) cfg.shortcuts;
      };
      force = true;
    };
  };
}
