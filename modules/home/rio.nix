{
  nixosConfig,
  config,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) colors font opacity;
in {
  config = lib.mkIf config.programs.rio.enable {
    programs.rio = {
      settings = {
        force-theme = "dark";
        fonts = {
          size = font.size;
          family = lib.head nixosConfig.fonts.fontconfig.defaultFonts.monospace;
          extras = lib.map (family: {inherit family;}) (lib.tail nixosConfig.fonts.fontconfig.defaultFonts.monospace);
          use-drawable-chars = true;
        };
        window = {
          opacity = opacity;
          decorations = "Disabled";
        };
        hints = {
          rules = [
            {
              regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
              hyperlinks = true;
              post-processing = true;
              persist = false;
              command.command = "xdg-open";
              binding = {
                key = "O";
                mods = ["Control" "Shift"];
              };
              mouse = {
                mods = ["Control"];
                enabled = true;
              };
            }
          ];
        };
        colors = with colors; {
          foreground = on_surface.hex;
          background = surface.hex;

          cursor = on_surface.hex;
          vi-cursor = primary.hex;

          black = color0.hex;
          red = color1.hex;
          green = color2.hex;
          yellow = color3.hex;
          blue = color4.hex;
          magenta = color5.hex;
          cyan = color6.hex;
          white = color7.hex;

          light-black = color8.hex;
          light-red = color9.hex;
          light-green = color10.hex;
          light-yellow = color11.hex;
          light-blue = color12.hex;
          light-magenta = color13.hex;
          light-cyan = color14.hex;
          light-white = color15.hex;
        };
        renderer = {
          disable-unfocused-render = true;
          target-fps = lib.mkDefault 60;
        };
      };
    };
  };
}
