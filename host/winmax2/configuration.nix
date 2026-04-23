{
  config,
  pkgs,
  inputs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedTCPPorts = [
      3000
    ];
  };

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  services.openssh.enable = true;

  services.udisks2.enable = true;

  services.pipewire.enable = true;

  programs.kdeconnect.enable = true;

  services.swapspace.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.dbus.enable = true;

  services.unblockneteasemusic.enable = true;

  hardware.bluetooth.enable = true;

  services.aria2.enable = true;

  services.nginx.enable = true;

  security.polkit.enable = true;

  services.searx.enable = true;

  services.mihomo.enable = true;

  programs.chromium = {
    enable = true;
    extraOpts = {
      RestoreOnStartup = 1;
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "layer(hyper)";
          };
          "hyper:S-C-A-M" = {
            tab = "capslock";
          };
        };
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  hm.programs.distrobox.enable = true;

  age.identityPaths = [
    "${config.user.home}/.ssh/id_ed25519"
  ];

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "niri-uwsm";
  };

  theme.wallpaper = pkgs.runCommand "wallpaper.png" {
    src = pkgs.fetchurl {
      url = "https://i.pixiv.re/img-original/img/2018/05/26/23/51/57/68936009_p0.jpg";
      sha256 = "sha256-s8eDdjoZaTWcSodD3xOQX6iGYHLa9sf9DnTw8Dzitgc=";
    };
    nativeBuildInputs = [pkgs.imagemagick];
  } "magick $src -fuzz 10% -trim +repage $out";

  hm.programs.uwsm.desktopEnv.niri = {
    QT_SCALE_FACTOR = "1.5";
  };
  programs.niri.enable = true;
  hm.programs.niri.settings = {
    outputs."eDP-1".scale = 1.5;
  };

  services.swaylock.enable = true;

  programs.localsend = {
    enable = true;
    package = pkgs.gtk-nocsd.wrapper pkgs.localsend;
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

  hm.services.cliphist.enable = true;

  hm.programs.aria2.enable = true;

  hm.programs.cava.enable = true;

  hm.programs.zathura.enable = true;

  hm.programs.swayimg.enable = true;

  hm.programs.yazi.enable = true;

  hm.programs.alacritty.enable = true;

  hm.xdg.terminal-exec = {
    enable = true;
    settings.niri = ["Alacritty.desktop"];
  };

  hm.programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

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

    inputs.browser-previews.packages.${stdenv.hostPlatform.system}.google-chrome
    telegram-desktop
    (gtk-nocsd.wrapper netease-cloud-music-gtk)

    mcaselector
    (gtk-nocsd.wrapper gnome-mines)
  ];

  hm.games = {
    ksre.enable = true;
    minecraft.enable = true;
    retroarch.enable = true;

    steam.shortcuts."BD2" = {
      appname = "Brown Dust 2";
      exe = "${pkgs.requireFile {
        name = "BD2StarterSetup_gpg_240430.exe";
        url = "https://www.browndust2.com/";
        hash = "sha256-+6UqG1E6MiutypOgZmTjpjofqr5Vfablb6bI6fOhQKw=";
      }}";
    };
    steam.shortcuts."PVZRH" = {
      appname = "Plants vs. Zombies: RH";
      exe = "${pkgs.pvz-rh}/PlantsVsZombiesRH.exe";
    };
  };
}
