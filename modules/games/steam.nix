{
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.steam.enable {
      programs.steam = {
        extraCompatPackages = with pkgs; [
          dwproton-bin
        ];
      };
    };
  };

  # https://github.com/kira-bruneau/nixos-config/blob/d2561703b25cfd72c1e650a1dfc4d07ec26e230b/home/hosts/peridot.nix
  # https://github.com/ChrisOboe/json2steamshortcut/blob/7d43d5b6e198542649c712573b91f27247068aed/flake.nix
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.services.steam;

    dataDir =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "Library/Application Support"
      else config.xdg.dataHome;

    json2vdf = name: value:
      pkgs.runCommandLocal name
      {
        nativeBuildInputs = [
          pkgs.python3
          pkgs.python3Packages.vdf
        ];

        value = builtins.toJSON value;
        passAsFile = ["value"];
      }
      ''python ${./json2vdf.py} "$valuePath" "$out"'';

    shortcuts = lib.mapAttrsToList (_: lib.filterAttrs (_: value: value != null)) cfg.shortcuts;

    grids = lib.concatMapAttrs (_: {
      id,
      grid,
      horizontal,
      hero,
      logo,
    }:
      lib.filterAttrs (_: value: value != null) {
        "${toString id}p.png" = grid;
        "${toString id}.png" = horizontal;
        "${toString id}_hero.png" = hero;
        "${toString id}_logo.png" = logo;
      })
    cfg.grids;
  in {
    options.services.steam = {
      enable = lib.mkEnableOption "steam";

      steamUserId = lib.mkOption {
        type = lib.types.int;
        default = 1072827295;
      };

      userConfigDir = lib.mkOption {
        type = lib.types.str;
        internal = true;
        default = "${dataDir}/Steam/userdata/${builtins.toString cfg.steamUserId}/config";
      };

      shortcuts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule ({name, ...}: {
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
                apply = v:
                  if lib.isList v
                  then lib.escapeShellArgs v
                  else v;
              };
            };
          })
        );
        default = {};
      };

      grids = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule ({name, ...}: {
            options = {
              id = lib.mkOption {
                type = lib.types.int;
              };
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
            config = lib.mkIf (cfg.shortcuts ? ${name}) {
              id = lib.mkForce (cfg.shortcuts.${name}.appid + 4294967296);
            };
          })
        );
        default = {};
      };
    };

    config = lib.mkIf cfg.enable {
      home.file = {
        "${cfg.userConfigDir}/shortcuts.vdf" = {
          source = json2vdf "shortcuts.vdf" {inherit shortcuts;};
          force = true;
        };
        "${cfg.userConfigDir}/grid" = {
          source = pkgs.linkFarm "grid" (lib.mapAttrsToList (name: path: {inherit name path;}) grids);
          force = true;
        };
      };
    };
  };

  flake.modules.homeManager.nixos = {
    osConfig,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf osConfig.programs.steam.enable {
      services.steam.enable = true;
      xdg.dataFile."Steam/.cef-enable-remote-debugging".source = pkgs.emptyFile;
    };
  };
}
