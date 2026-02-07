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
