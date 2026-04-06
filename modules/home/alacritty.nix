{
  nixosConfig,
  config,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) colors font opacity;
in {
  programs.alacritty = lib.mkIf config.programs.alacritty.enable {
    settings = {
      font = {
        normal = {
          family = font.name;
          style = "Regular";
        };
        size = font.size;
      };
      window.opacity = opacity;
      colors = with colors; {
        primary = {
          foreground = on_surface.hex;
          background = surface.hex;
          bright_foreground = on_surface.hex;
        };
        normal = {
          black = color0.hex;
          red = color1.hex;
          green = color2.hex;
          yellow = color3.hex;
          blue = color4.hex;
          magenta = color5.hex;
          cyan = color6.hex;
          white = color7.hex;
        };
        bright = {
          black = color8.hex;
          red = color9.hex;
          green = color10.hex;
          yellow = color11.hex;
          blue = color12.hex;
          magenta = color13.hex;
          cyan = color14.hex;
          white = color15.hex;
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
