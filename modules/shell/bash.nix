{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.bash.enable {
      programs.bash = {
        enableCompletion = true;
        historyControl = ["ignoredups"];
        initExtra = lib.mkOrder 0 ''
          PS0=
          PS1='\[\e[30m\e[46m\] '$(. /etc/os-release;printf "%s" "$NAME")' \[\e[44m\] \u@\h:\w \[\e[0m\]\n\$ '
        '';
      };
    };
  };
}
