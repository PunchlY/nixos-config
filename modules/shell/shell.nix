{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    home.shellAliases = {
      ".." = "cd ..";

      grep = lib.mkIf config.programs.grep.enable "grep --color=auto";

      mx = "chmod a+x";

      cls = "clear";
    };
  };
}
