{
  config,
  lib,
  pkgs,
  inputs,
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

    font = {
      size = lib.mkOption {
        default = 14;
        type = with lib.types; either ints.unsigned float;
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
    theme.colors =
      builtins.mapAttrs
      (
        _name: value:
          value
          // {
            hex_stripped = builtins.substring 1 6 value.hex;
          }
      )
      (
        lib.importJSON (
          pkgs.runCommand "generated-theme" {
            src = pkgs.runCommand "wallpaper-resize.png" {
              src = cfg.wallpaper;
              nativeBuildInputs = [pkgs.imagemagick];
            } "magick $src -resize 128x128 $out";
            nativeBuildInputs = [
              inputs.md3.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          } "md3 --dark <$src >$out"
        )
      );

    environment.variables.XCURSOR_SIZE = toString cfg.cursor.size;

    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        maple-mono.Normal-NF-CN
        noto-fonts-cjk-sans
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        material-icons
        lmmath
      ];
      fontconfig.defaultFonts =
        lib.genAttrs
        [
          "monospace"
          "serif"
          "sansSerif"
        ]
        (_family:
          lib.mkOrder 0 [
            "Maple Mono Normal NF CN"
            "Noto Sans Mono CJK SC"
            "Noto Sans Mono"
            "Noto Color Emoji"
            "Noto Emoji"
          ])
        // {
          emoji = lib.mkOrder 0 [
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
    };
  };

  config.home-manager.sharedModules = lib.singleton {
    home.packages = config.fonts.packages;
  };
}
