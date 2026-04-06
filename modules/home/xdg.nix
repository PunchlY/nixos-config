{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils
  ];

  home.preferXdgDirectories = true;

  xdg = {
    enable = true;
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
