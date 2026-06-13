{
  inputs,
  lib,
  moduleWithSystem,
  ...
}: {
  flake-file.inputs = {
    md3.url = "github:PunchlY/md3";
  };

  flake.modules.nixos.theme = moduleWithSystem ({inputs',...}: {
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
        pkgs.runCommand "generated-theme" {
          src = cfg.wallpaper;
          nativeBuildInputs = [
            inputs'.md3.packages.default
          ];
          preferLocalBuild = true;
        } "md3 --dark <$src >$out"
        |> lib.importJSON
        |> builtins.mapAttrs (
          _name: value:
            value
            // {
              hex_stripped = builtins.substring 1 6 value.hex;
            }
        );
    };
  });
}
