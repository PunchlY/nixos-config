# https://github.com/kira-bruneau/nixos-config/blob/d2561703b25cfd72c1e650a1dfc4d07ec26e230b/home/hosts/peridot.nix
# https://github.com/ChrisOboe/json2steamshortcut/blob/7d43d5b6e198542649c712573b91f27247068aed/flake.nix

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

    grids = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          freeformType = lib.types.attrsOf lib.types.anything;
          options = {
            grid = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
            horizontal = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
            hero = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
            logo = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      "${cfg.userConfigDir}/shortcuts.vdf" = {
        source = json2vdf "shortcuts.vdf" {
          shortcuts = lib.mapAttrsToList (
            _: lib.attrsets.filterAttrs (_: value: value != null)
          ) cfg.shortcuts;
        };
        force = true;
      };
    }
    // lib.attrsets.mergeAttrsList (
      lib.attrsets.mapAttrsToList (
        name:
        {
          grid,
          horizontal,
          hero,
          logo,
        }:
        if (builtins.hasAttr name cfg.shortcuts) then
          (
            let
              id = toString (cfg.shortcuts.${name}.appid + 4294967296);
            in
            {
              "${cfg.userConfigDir}/grid/${id}p.png" = lib.mkIf (grid != null) {
                source = grid;
                force = true;
              };
              "${cfg.userConfigDir}/grid/${id}.png" = lib.mkIf (horizontal != null) {
                source = horizontal;
                force = true;
              };
              "${cfg.userConfigDir}/grid/${id}_hero.png" = lib.mkIf (hero != null) {
                source = hero;
                force = true;
              };
              "${cfg.userConfigDir}/grid/${id}_logo.png" = lib.mkIf (logo != null) {
                source = logo;
                force = true;
              };
            }
          )
        else
          null
      ) cfg.grids
    );
  };
}
