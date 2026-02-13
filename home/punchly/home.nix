{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:

{
  home.stateVersion = "26.05";

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

  xdg.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
  xdg.terminal-exec.enable = true;
  xdg.autostart.enable = true;
  xdg.mime.enable = true;

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
      SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
      PROJECTS = "${config.home.homeDirectory}/src";
      GAME = "${config.home.homeDirectory}/med/games";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
    };
    # defaultApplicationPackages = [ config.home.path ];
  };

  xdg.terminal-exec.settings = {
    niri = [ "foot.desktop" ];
  };

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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  # services.easyeffects.enable = true;

  services.cliphist.enable = true;

  programs.aria2.enable = true;

  programs.cava.enable = true;

  # programs.zathura.enable = true;

  programs.imv.enable = true;

  programs.yazi.enable = true;

  programs.foot.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.wiliwili.enable = true;

  programs.mpv.enable = true;

  programs.swaylock.enable = true;

  programs.fuzzel.enable = true;

  services.mako = {
    enable = true;
    settings.on-button-left = ''exec makoctl menu -n "$id" -- fuzzel --dmenu --prompt "Select action: " --minimal-lines'';
  };

  services.steam-shortcuts = {
    enable = true;
    steamUserId = 1072827295;
  };
}
