{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.theme) colors font opacity;
in
{
  xdg.terminal-exec.settings = {
    niri = [ "foot.desktop" ];
  };

  xdg.desktopEntries.foot = {
    name = "Foot";
    type = "Application";
    genericName = "Terminal";
    comment = "A wayland native terminal emulator";
    icon = "foot";
    exec = "foot";
    categories = [
      "System"
      "TerminalEmulator"
    ];
    startupNotify = true;
    terminal = false;
    settings = {
      Keywords = "shell;prompt;command;commandline;";
      X-TerminalArgExec = "--";
      X-TerminalArgTitle = "--title";
      X-TerminalArgAppId = "--app-id";
      X-TerminalArgDir = "--working-directory";
      X-TerminalArgHold = "--hold";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot-direct";
        font = "${font.name}:size=${toString font.size}";
        dpi-aware = "no";
      };
      colors = with colors.hex_stripped; {
        alpha = opacity;
        foreground = on_surface;
        background = surface;
        regular0 = black;
        regular1 = red_dim;
        regular2 = green_dim;
        regular3 = yellow_dim;
        regular4 = blue_dim;
        regular5 = magenta_dim;
        regular6 = cyan_dim;
        regular7 = white;
        bright0 = gray;
        bright1 = red;
        bright2 = green;
        bright3 = yellow;
        bright4 = blue;
        bright5 = magenta;
        bright6 = cyan;
        bright7 = white_bright;
      };

      desktop-notifications.command = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";

      key-bindings = {
        pipe-command-output = ''[sh -c "xdg-terminal-exec --app-id=pipe-command-output -- nvim /proc/$$/fd/0"] Control+Shift+g'';
      };
    };
  };
}
