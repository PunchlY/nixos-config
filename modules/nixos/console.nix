{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.theme) colors;
in
{
  config = lib.mkIf config.console.enable {
    console = {
      colors = with colors.hex_stripped; [
        black
        red_dim
        green_dim
        yellow_dim
        blue_dim
        magenta_dim
        cyan_dim
        white
        gray
        red
        green
        yellow
        blue
        magenta
        cyan
        white_bright
      ];
    };
  };
}
