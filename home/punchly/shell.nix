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

  programs.bat.enable = true;

  programs.ripgrep.enable = true;

  programs.television = {
    enable = true;
    settings = {
      ui = {
        orientation = "portrait";
      };
      ui.input_bar = {
        position = "bottom";
        border_type = "thick";
      };
      ui.results_panel = {
        border_type = "thick";
      };
      ui.preview_panel = {
        size = 70;
        border_type = "thick";
      };
      ui.remote_control.disabled = true;
    };
    channels = {
      tldr = {
        metadata = {
          name = "tldr";
          description = "Browse and preview TLDR help pages";
          requirements = [ "tldr" ];
        };
        source.command = "tldr --list";
        preview.command = "tldr '{}'";
        keybindings.ctrl-e = "actions:open";
        actions.open = {
          description = "Open TLDR page in pager";
          command = "tldr '{}' | less";
          mode = "fork";
        };
      };
      journal = {
        metadata = {
          name = "journal";
          description = "Browse systemd journal log identifiers and their logs";
          requirements = [ "journalctl" ];
        };
        source.command = "journalctl --field SYSLOG_IDENTIFIER 2>/dev/null | sort -f";
        preview.command = "journalctl -b --no-pager -o short-iso -n 50 SYSLOG_IDENTIFIER='{}' 2>/dev/null";
        actions = {
          logs = {
            description = "Follow live logs for the selected identifier";
            command = "journalctl -f SYSLOG_IDENTIFIER='{}'";
            mode = "execute";
          };
          full = {
            description = "View all logs for the selected identifier in a pager";
            command = "journalctl -b --no-pager -o short-iso SYSLOG_IDENTIFIER='{}' | less";
            mode = "fork";
          };
        };
      };
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
        # https://github.com/elenapan/dotfiles/blob/deddf27a486535ea555ec87d2ae7ee895d02fb3e/bin/bunnyfetch
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
