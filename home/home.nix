{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    libnotify
    brightnessctl
    wl-clipboard-rs
    wireplumber
    playerctl
    exiftool
    android-tools
    appimage-run
    xdg-user-dirs

    gtrash
    impala
    bluetui

    (gtk-nocsd.wrapper pwvucontrol)
    (gtk-nocsd.wrapper helvum)

    scrcpy

    google-chrome
    telegram-desktop
    (gtk-nocsd.wrapper netease-cloud-music-gtk)

    (writeShellScriptBin "webcam" ''
      exec mpv av://v4l2:/dev/video0 --profile=low-latency --untimed
    '')
  ];

  xdg.desktopEntries.bluetui = {
    name = "Bluetui";
    genericName = "Bluetooth Manager";
    exec = "bluetui";
    terminal = true;
  };

  xdg.desktopEntries.impala = {
    name = "Impala";
    genericName = "Wifi Manager";
    exec = "impala";
    terminal = true;
  };

  xdg.desktopEntries.webcam = {
    name = "webcam";
    exec = "webcam";
  };

  home.preferXdgDirectories = true;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  # services.easyeffects.enable = true;

  services.cliphist.enable = true;

  programs.aria2.enable = true;

  # programs.cava.enable = true;

  # programs.zathura.enable = true;

  programs.imv.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  services.udiskie.enable = true;

  xdg.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
  xdg.terminal-exec.enable = true;
  xdg.autostart.enable = true;
  xdg.mime.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      config.programs.mpv.package
      config.programs.imv.package
      telegram-desktop
      google-chrome
      config.programs.neovim.package
    ];
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = null;
    publicShare = null;
    documents = "${config.home.homeDirectory}/doc";
    download = "${config.home.homeDirectory}/dls";
    music = "${config.home.homeDirectory}/med/music";
    pictures = "${config.home.homeDirectory}/med/pictures";
    videos = "${config.home.homeDirectory}/med/videos";
    templates = "${config.xdg.userDirs.documents}/templates";

    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/src";
      XDG_GAME_DIR = "${config.home.homeDirectory}/med/games";
    };
  };
}
