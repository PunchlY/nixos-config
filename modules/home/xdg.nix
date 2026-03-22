{
  config,
  lib,
  ...
}:
{
  home.preferXdgDirectories = lib.mkDefault config.xdg.enable;

  home.shellAliases = lib.mkIf config.xdg.enable {
    # o = "env --unset=NIXOS_XDG_OPEN_USE_PORTAL xdg-open";
    o = "xdg-open";
  };

  xdg = lib.mkIf config.xdg.enable {
    portal = {
      enable = true;
      xdgOpenUsePortal = lib.mkDefault true;
    };
    terminal-exec.enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      createDirectories = lib.mkDefault true;

      desktop = null;
      publicShare = null;
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/dls";
      music = "${config.home.homeDirectory}/med/music";
      pictures = "${config.home.homeDirectory}/med/pictures";
      videos = "${config.home.homeDirectory}/med/videos";
      templates = "${config.xdg.userDirs.documents}/templates";

      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
        PROJECTS = "${config.home.homeDirectory}/src";
        GAME = "${config.home.homeDirectory}/med/games";
      };
    };
  };

}
