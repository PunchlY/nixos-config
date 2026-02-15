# https://github.com/kira-bruneau/nixos-config/blob/d2561703b25cfd72c1e650a1dfc4d07ec26e230b/home/hosts/peridot.nix
# https://github.com/ChrisOboe/json2steamshortcut/blob/7d43d5b6e198542649c712573b91f27247068aed/flake.nix

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.steam;

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

  shortcuts = lib.mapAttrsToList (_: lib.filterAttrs (_: value: value != null)) cfg.shortcuts;

  grids = lib.concatMapAttrs (
    name:
    {
      grid,
      horizontal,
      hero,
      logo,
    }:
    lib.optionalAttrs (builtins.hasAttr name cfg.shortcuts) (
      let
        id = toString (cfg.shortcuts.${name}.appid + 4294967296);
      in
      lib.filterAttrs (_: value: value != null) {
        "${id}p.png" = grid;
        "${id}.png" = horizontal;
        "${id}_hero.png" = hero;
        "${id}_logo.png" = logo;
      }
    )
  ) cfg.grids;
in
{
  options.services.steam = {
    enable = lib.mkEnableOption "steam";

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
                type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
                apply = v: lib.escapeShellArgs (if lib.isList v then v else [ v ]);
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
        source = json2vdf "shortcuts.vdf" { inherit shortcuts; };
        force = true;
      };
      "${cfg.userConfigDir}/grid" = {
        source = pkgs.runCommand "grid" { } (
          ''
            mkdir $out
            cd $out
          ''
          + lib.concatStrings (
            lib.mapAttrsToList (name: file: ''
              ln -s ${
                lib.escapeShellArgs [
                  file
                  name
                ]
              }
            '') grids
          )
        );
        force = true;
      };
    };
  };
}
