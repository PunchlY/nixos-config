{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    just
    nix-output-monitor
    moreutils
    wget
    q
    yq-go
    tree
    zip
    unzip
    tlrc
    nodejs
    nixfmt
    fx

    (writeShellScriptBin "ips" ''
      ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}'
    '')
    (writeShellScriptBin "pkgs" ''
      printenv PATH | tr ':' '\n' | grep '^/nix/store' | sort -u | xargs -d "\n" -r nix derivation show | jq -r .[].name
    '')
  ];

  xdg.configFile."tlrc/config.toml" = {
    source = (pkgs.formats.toml { }).generate "config.toml" {
      cache.languages = [ "zh" ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Punchly";
      user.email = "punchly9lin@gmail.com";
    };
  };

  programs.jq.enable = true;

  programs.bottom.enable = true;

  programs.mcfly.enable = true;
  programs.fd.enable = true;
  programs.grep.enable = true;

  programs.bun = {
    enable = true;
    settings = {
      install.linker = "isolated";
    };
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    colors = "auto";
    icons = "auto";
    git = true;
    extraOptions = [
      "--classify=auto"
      "--group-directories-first"
      "--hyperlink"
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.shellAliases = {
    ".." = "cd ..";

    grep = "grep --color=auto";

    mx = "chmod a+x";

    cls = "clear";

    # o = "env --unset=NIXOS_XDG_OPEN_USE_PORTAL xdg-open";
    o = "xdg-open";
    n = "nvim";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" ];
    initExtra = lib.mkOrder 0 ''
      PS0=
      PS1='\[\e[30m\e[46m\] '$(. /etc/os-release;printf "%s" "$NAME")' \[\e[44m\] \u@\h:\w \[\e[0m\]\n\$ '

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
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetchMinimal;

    settings = {
      logo = {
        # https://github.com/elenapan/dotfiles/blob/master/bin/bunnyfetch
        source = lib.strings.concatMapStrings (x: "    " + x + "\n") [
          ''$1(\ /)''
          "( . .)"
          ''c($2"$1)($2"$1)''
        ];
        type = "data";
        position = "top";
        padding = {
          top = 0;
          left = 0;
          right = 0;
        };
        color = {
          "1" = "light_white";
          "2" = "red";
        };
      };
      display = {
        color = "blue";
        separator = " ";
      };
      modules = [
        {
          key = " OS";
          type = "os";
        }
        {
          key = "KER";
          type = "kernel";
        }
        {
          key = " SH";
          type = "shell";
        }
        {
          key = "TER";
          type = "terminal";
        }
        {
          key = " WM";
          type = "wm";
        }
        {
          paddingLeft = 4;
          type = "colors";
        }
      ];
    };
  };
}
