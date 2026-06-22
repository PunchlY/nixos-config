{withSystem, ...}: let
  mkColors = pkgs: wallpaper:
    withSystem pkgs.stdenv.hostPlatform.system ({inputs', ...}:
      pkgs.runCommandLocal "generated-theme" {
        src = wallpaper;
        nativeBuildInputs = [
          inputs'.md3.packages.default
        ];
      } "md3 --dark <$src >$out"
      |> pkgs.lib.importJSON
      |> builtins.mapAttrs (
        _name: value:
          value
          // {
            hex_stripped = builtins.substring 1 6 value.hex;
          }
      ));

  shared = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.theme;
  in {
    options.theme = {
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha.src;
      };

      colors = lib.mkOption {internal = true;};

      opacity = lib.mkOption {
        type = lib.types.float;
        default = 0.75;
      };
    };
    config = {
      theme.colors = mkColors pkgs cfg.wallpaper;
    };
  };
in {
  flake-file.inputs = {
    md3.url = "github:PunchlY/md3";
  };

  flake.modules.nixos.theme = {
    imports = [shared];
  };

  flake.modules.homeManager.theme = {
    imports = [shared];
  };
}
