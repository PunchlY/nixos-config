{withSystem, ...}: let
  mkColors = pkgs: wallpaper:
    withSystem pkgs.stdenv.hostPlatform.system ({inputs', ...}:
      pkgs.runCommandLocal "generated-theme" {
        inherit wallpaper;
        nativeBuildInputs = [
          pkgs.imagemagick
          inputs'.oktheme.packages.default
        ];
      } ''
        read -r source < <(
          magick "$wallpaper" \
            -seed 0 \
            -resize '256>' \
            -colorspace oklch \
            -kmeans 8 \
            -colorspace oklch \
            -format '%c' \
            histogram:info: |
            sort -nr
        )
        if [[ $source =~ oklch\(([0-9.-]+),([0-9.-]+),([0-9.-]+)\) ]]; then
          l="''${BASH_REMATCH[1]}"
          c="''${BASH_REMATCH[2]}"
          h="''${BASH_REMATCH[3]}"
        else
          exit 1
        fi
        oktheme "oklch($l $c $h)" >$out
      ''
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
    oktheme.url = "github:PunchlY/oktheme";
  };

  flake.modules.nixos.theme = {
    imports = [shared];
  };

  flake.modules.homeManager.theme = {
    imports = [shared];
  };
}
