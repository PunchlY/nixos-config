{lib, ...}: {
  flake.homeModules.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      just
      nix-output-monitor
      nh
      nurl
      moreutils
      wget
      q
      yq-go
      tree

      (writeShellScriptBin "ips" ''
        ip addr show "$@" | awk '/inet / {print $2}'
      '')
      (writeShellScriptBin "pkgs" ''
        if [ $# -gt 0 ]; then
          which -- "$@"
        else
          printenv PATH | tr ':' '\n'
        fi \
        | xargs -r realpath -qe \
        | awk '!seen[$0]++' \
        | grep '^/nix/store/' \
        | xargs -r nix derivation show \
        | if [ -t 1 ]; then
          jq -r '.derivations.[] | "\u001b]8;;file://" + .env.out + "\u0007" + .name + "\u001b]8;;\u0007"'
        else
          jq -r .derivations.[].name
        fi
      '')
    ];

    programs.tlrc.enable = true;

    programs.jq.enable = true;

    programs.bottom.enable = true;

    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = ["--disable-up-arrow"];
    };

    programs.fd.enable = true;

    programs.grep.enable = true;

    programs.bat.enable = true;

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

    home.shellAliases = {
      ".." = "cd ..";

      grep = "grep --color=auto";

      mx = "chmod a+x";

      cls = "clear";
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoredups"];
      initExtra = lib.mkOrder 0 ''
        PS0=
        PS1='\[\e[30m\e[46m\] '$(. /etc/os-release;printf "%s" "$NAME")' \[\e[44m\] \u@\h:\w \[\e[0m\]\n\$ '
      '';
    };
  };
}
