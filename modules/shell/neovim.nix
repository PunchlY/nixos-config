{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.neovim.enable {
      home.shellAliases = {
        n = "nvim";
      };

      programs.neovim = {
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };

      programs.bash = {
        sessionVariables.EDITOR = "nvim";
      };
    };
  };
}
