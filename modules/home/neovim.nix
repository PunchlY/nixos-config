{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.shellAliases = lib.mkIf config.programs.neovim.enable {
    n = "nvim";
  };

  programs.neovim = {
    enable = lib.mkDefault true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  programs.bash = lib.mkIf config.programs.neovim.enable {
    sessionVariables.EDITOR = "nvim";
  };
}
