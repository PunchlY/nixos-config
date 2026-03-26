{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (nixosConfig.theme) colors font opacity;
in
{
  config = lib.mkIf config.programs.foot.enable {
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

    programs.foot.settings = {
      main = {
        term = "foot-direct";
        font = "${font.name}:size=${toString font.size}";
        dpi-aware = "no";
      };
      colors-dark = {
        alpha = opacity;
        foreground = colors.on_surface.hex_stripped;
        background = colors.surface.hex_stripped;
        flash = colors.primary.hex_stripped;
      }
      // builtins.listToAttrs (
        builtins.genList (i: {
          name = "regular${toString i}";
          value = colors."color${toString i}".hex_stripped;
        }) 8
      )
      // builtins.listToAttrs (
        builtins.genList (i: {
          name = "bright${toString i}";
          value = colors."color${toString (i + 8)}".hex_stripped;
        }) 8
      )
      // builtins.listToAttrs (
        builtins.genList (i: {
          name = toString i;
          value = colors."color${toString i}".hex_stripped;
        }) 256
      );

      key-bindings = {
        pipe-command-output = ''[sh -c 'foot -- nvim /proc/$$/fd/0'] Control+Shift+g'';
      };
    };

    programs.bash.initExtra = lib.mkOrder 550 ''
      __add_prompt_command() {
        local command=$1 IFS=$' \t\n'
        if ((BASH_VERSINFO[0] > 5 || BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 1)); then
          if [[ " ''${PROMPT_COMMAND[*]-} " != *" $command "* ]]; then
            PROMPT_COMMAND[0]=''${PROMPT_COMMAND[0]:-}
            eval 'PROMPT_COMMAND+=("$command")'
          fi
        elif [[ -z ''${PROMPT_COMMAND-} ]]; then
          PROMPT_COMMAND="$command"
        elif [[ $PROMPT_COMMAND != *"$command"* ]]; then
          PROMPT_COMMAND="$command;''${PROMPT_COMMAND#;}"
        fi
      }

      PS0+='\e]133;C\e\\'
      command_done() {
        printf '\e]133;D\e\\'
      }
      __add_prompt_command command_done

      prompt_marker() {
        printf '\e]133;A\e\\'
      }
      __add_prompt_command prompt_marker

      osc7_cwd() {
        local strlen=''${#PWD}
        local encoded=""
        local pos c o
        for (( pos=0; pos<strlen; pos++ )); do
          c=''${PWD:$pos:1}
          case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] ) o="$c" ;;
            * ) printf -v o '%%%02X' "'$c" ;;
          esac
          encoded+="''${o}"
        done
        printf '\e]7;file://%s%s\e\\' "''${HOSTNAME}" "''${encoded}"
      }
      __add_prompt_command osc7_cwd

      unset -f __add_prompt_command
    '';
  };
}
