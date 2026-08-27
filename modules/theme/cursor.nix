{...}: let
  shared = {
    pkgs,
    lib,
    ...
  }: {
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
  };
in {
  flake.modules.nixos.theme = {config, ...}: let
    cfg = config.theme;
  in {
    imports = [shared];

    config = {
      environment.variables.XCURSOR_SIZE = toString cfg.cursor.size;
    };
  };

  flake.modules.homeManager.theme = {config, ...}: {
    imports = [shared];

    home.pointerCursor = {
      enable = true;
      inherit (config.theme.cursor) name package size;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
