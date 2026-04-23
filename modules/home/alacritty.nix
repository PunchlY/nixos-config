{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (nixosConfig.theme) colors font opacity;
in {
  config = lib.mkIf config.programs.alacritty.enable {
    xdg.desktopEntries.Alacritty = {
      name = "Alacritty";
      type = "Application";
      genericName = "Terminal";
      comment = "A fast, cross-platform, OpenGL terminal emulator";
      icon = "Alacritty";
      exec = "alacritty";
      categories = [
        "System"
        "TerminalEmulator"
      ];
      startupNotify = true;
      terminal = false;
      settings = {
        X-TerminalArgExec = "-e";
        X-TerminalArgTitle = "--title=";
        X-TerminalArgAppId = "--class=";
        X-TerminalArgDir = "--working-directory=";
        X-TerminalArgHold = "--hold";
      };
    };

    programs.alacritty = {
      package = lib.mkDefault pkgs.alacritty-graphics;
      settings = {
        font = {
          normal = {
            family = "monospace";
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
        hints.enabled = let
          regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
        in [
          {
            inherit regex;
            hyperlinks = true;
            command = "xdg-open";
            post_processing = true;
            persist = false;
            mouse = {
              mods = "Control";
              enabled = true;
            };
          }
          {
            inherit regex;
            hyperlinks = true;
            action = "Select";
            post_processing = true;
            persist = false;
            mouse = {
              enabled = true;
            };
          }
        ];
        keyboard.bindings = [
          {
            key = "N";
            mods = "Shift|Control";
            action = "CreateNewWindow";
          }
        ];
      };
    };
  };
}
