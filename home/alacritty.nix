{
  config,
  lib,
  ...
}:
let
  inherit (config.theme) colors font opacity;
in
{
  programs.alacritty = {
    enable = false;
    settings = {
      font = {
        normal = {
          family = font.name;
          style = "Regular";
        };
        size = font.size;
      };
      window.opacity = opacity;
      colors = with colors.hex; {
        primary = {
          foreground = on_surface;
          background = surface;
          bright_foreground = on_surface;
        };
        normal = {
          black = black;
          red = red_dim;
          green = green_dim;
          yellow = yellow_dim;
          blue = blue_dim;
          magenta = magenta_dim;
          cyan = cyan_dim;
          white = white;
        };
        bright = {
          black = gray;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          magenta = magenta;
          cyan = cyan;
          white = white;
        };
      };
      keyboard.bindings = [
        {
          key = "N";
          mods = "Shift|Control";
          action = "CreateNewWindow";
        }
      ];
    };
  };
}
