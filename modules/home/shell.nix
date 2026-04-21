{
  lib,
  pkgs,
  ...
}: {
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
    zip
    unzip
    tlrc
    nodejs
    fx

    (writeShellScriptBin "ips" ''
      ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}'
    '')
    (writeShellScriptBin "pkgs" ''
      printenv PATH | tr ':' '\n' | grep '^/nix/store' | sort -u | xargs -d "\n" -r nix derivation show | jq -r .derivations.[].name
    '')
    (writeShellScriptBin "pkg" ''
      which "$1" | xargs -r realpath | xargs -r nix derivation show | jq -r .derivations.[].name
    '')
  ];

  xdg.configFile."tlrc/config.toml" = {
    source = (pkgs.formats.toml {}).generate "config.toml" {
      cache.languages = ["zh"];
    };
  };

  programs.jq.enable = true;

  programs.bottom.enable = true;

  # programs.mcfly.enable = true;
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    flags = ["--disable-up-arrow"];
  };

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
}
