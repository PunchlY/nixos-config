{
  flake-file.inputs = {
    md3.url = "github:PunchlY/md3";
  };

  flake.modules.nixos.theme = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.theme;
  in {
    options.theme = {
      cursor = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Bibata-Modern-Classic";
        };
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bibata-cursors;
        };
        size = lib.mkOption {
          type = lib.types.int;
          default = 32;
        };
      };
    };

    config = {
      environment.variables.XCURSOR_SIZE = toString cfg.cursor.size;
    };
  };

  flake.modules.homeManager.theme = {osConfig, ...}: {
    home.pointerCursor = {
      inherit (osConfig.theme.cursor) name package size;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
