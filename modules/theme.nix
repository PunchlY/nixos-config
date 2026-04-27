{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    md3.url = "github:PunchlY/md3";
  };

  flake.modules.nixos.base = {
    config,
    pkgs,
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
      theme.colors =
        builtins.mapAttrs (_name: value:
          value
          // {
            hex_stripped = builtins.substring 1 6 value.hex;
          })
        (lib.importJSON (pkgs.runCommand "generated-theme" {
          src = pkgs.runCommand "wallpaper-resize.png" {
            src = cfg.wallpaper;
            nativeBuildInputs = [pkgs.imagemagick];
          } "magick $src -resize 128x128 $out";
          nativeBuildInputs = [
            inputs.md3.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        } "md3 --dark <$src >$out"));
    };
  };
}
