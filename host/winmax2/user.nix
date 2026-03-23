{
  config,
  pkgs,
  lib,
  browser-previews,
  ...
}:
{
  age.identityPaths = [
    "${config.user.home}/.ssh/id_ed25519"
  ];

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "niri";
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      no-mouse
      font-dpi=144
    '';
  };

  theme.wallpaper = pkgs.wallpapers.pixiv_68936009;

  services.displayManager.defaultSession = lib.mkForce "niri";

  programs.niri = {
    enable = true;
    settings = {
      outputs."eDP-1".scale = 1.5;
    };
  };

  programs.localsend = {
    enable = true;
    package = pkgs.gtk-nocsd.wrapper pkgs.localsend;
  };

  hm.home.shellAliases = {
    spawn = ''niri msg action spawn -- env --chdir="$(pwd)"'';
  };

  hm.i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  hm.programs.git.enable = true;

  hm.programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  # hm.services.easyeffects.enable = true;

  hm.services.cliphist.enable = true;

  hm.programs.aria2.enable = true;

  hm.programs.cava.enable = true;

  # hm.programs.zathura.enable = true;

  hm.programs.imv.enable = true;

  hm.programs.yazi.enable = true;

  hm.programs.foot.enable = true;

  hm.programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  hm.programs.swaylock.enable = true;

  hm.programs.wiliwili.enable = true;

  hm.programs.mpv.enable = true;

  hm.programs.fuzzel.enable = true;

  hm.programs.kew.enable = true;

  hm.services.mako = {
    enable = true;
    settings.on-button-left = ''exec makoctl menu -n "$id" -- fuzzel --dmenu --prompt "Select action: " --minimal-lines'';
  };

  hm.programs.opencode.enable = true;

  hm.services.bar.enable = true;

  hm.programs.retroarch.enable = true;

  hm.xdg.desktopEntries.bluetui = {
    name = "Bluetui";
    genericName = "Bluetooth Manager";
    exec = "bluetui";
    terminal = true;
  };

  hm.xdg.desktopEntries.impala = {
    name = "Impala";
    genericName = "Wifi Manager";
    exec = "impala";
    terminal = true;
  };

  hm.xdg.desktopEntries.webcam = {
    name = "webcam";
    exec = "mpv av://v4l2:/dev/video0 --profile=low-latency --untimed";
  };

  hm.xdg.desktopEntries.gtrash = {
    name = "grash";
    genericName = "Trash Manager";
    exec = "gtrash restore";
    terminal = true;
  };

  hm.home.packages = with pkgs; [
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
    (gtk-nocsd.wrapper crosspipe)

    scrcpy

    browser-previews.packages.${stdenv.hostPlatform.system}.google-chrome
    telegram-desktop
    (gtk-nocsd.wrapper netease-cloud-music-gtk)

    (mcaselector.override {
      jre = zulu.override {
        enableJavaFX = true;
      };
    })
    (gtk-nocsd.wrapper gnome-mines)
  ];

  hm.services.steam.shortcuts."BD2" = {
    appname = "Brown Dust 2";
    exe = "${pkgs.requireFile {
      name = "BD2StarterSetup_gpg_240430.exe";
      url = "https://www.browndust2.com/";
      hash = "sha256-+6UqG1E6MiutypOgZmTjpjofqr5Vfablb6bI6fOhQKw=";
    }}";
  };

  hm.programs.hmcl = {
    enable = true;
    package =
      with pkgs;
      hmcl.override {
        hmclJdk = graalvmPackages.graalvm-ce;
        minecraftJdks = [
          graalvmPackages.graalvm-ce
        ];
      };
  };

  hm.services.steam.shortcuts."PVZRH" = {
    appname = "Plants Vs Zombies: RH";
    exe = "${pkgs.pvz-rh}/PlantsVsZombiesRH.exe";
  };
}
