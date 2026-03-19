{
  config,
  lib,
  pkgs,
  md3,
  ...
}:
let
  cfg = config.theme;
in
{
  options.theme = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = pkgs.wallpaper.default;
    };

    colors = lib.mkOption {
      internal = true;
    };

    font = rec {
      package = lib.mkPackageOption pkgs.maple-mono "Normal-NF-CN-unhinted" { };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Maple Mono Normal NF CN";
      };
      size = lib.mkOption {
        default = 14;
        type = with lib.types; either ints.unsigned float;
      };
    };

    emoji = {
      package = lib.mkPackageOption pkgs "noto-fonts-color-emoji" { };
      name = lib.mkOption {
        type = lib.types.str;
        default = "Noto Color Emoji";
      };
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.75;
    };

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
    theme.colors = rec {
      rgb = lib.importJSON (
        pkgs.runCommand "generated-theme" {
          src = pkgs.runCommand "wallpaper-resize.png" {
            src = cfg.wallpaper;
            nativeBuildInputs = [ pkgs.imagemagick ];
          } "magick $src -resize 128x128 $out";
          nativeBuildInputs = [
            md3.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        } "md3 --dark --json={rgb} <$src >$out"
      );
      hex = builtins.mapAttrs (name: value: "#${value}") hex_stripped;
      hex_stripped = builtins.mapAttrs (
        name:
        {
          r,
          g,
          b,
        }:
        lib.fixedWidthString 6 "0" (lib.toHexString (r * 65536 + g * 256 + b))
      ) rgb;
    };

    environment.variables.XCURSOR_SIZE = toString cfg.cursor.size;

    fonts = {
      enableDefaultPackages = false;
      packages = [
        cfg.font.package
        cfg.emoji.package
      ]
      ++ (with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        material-icons
        lmmath
      ]);
      fontconfig.defaultFonts =
        lib.genAttrs
          [
            "monospace"
            "serif"
            "sansSerif"
          ]
          (family: [
            cfg.font.name
            cfg.emoji.name
            "Noto Sans Mono"
            "Noto Sans Mono CJK SC"
            "Noto Color Emoji"
            "Noto Emoji"
          ])
        // {
          emoji = [
            cfg.emoji.name
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
    };
  };
}
