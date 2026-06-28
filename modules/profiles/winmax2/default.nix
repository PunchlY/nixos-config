{
  configurations.nixos.winmax2.theme = {
    enable = true;
    wallpaper = {
      runCommand,
      fetchurl,
      imagemagick,
    }:
      runCommand "wallpaper.png" {
        src = fetchurl {
          url = "https://pixiv.cat/68936009.jpg";
          sha256 = "sha256-s8eDdjoZaTWcSodD3xOQX6iGYHLa9sf9DnTw8Dzitgc=";
        };
        nativeBuildInputs = [imagemagick];
        preferLocalBuild = true;
      } "magick $src -fuzz 10% -trim +repage $out";
  };

  configurations.nixos.winmax2.module = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.plymouth.enable = true;

    networking.networkmanager.enable = true;
    networking.firewall = {
      allowedTCPPorts = [
        3000
      ];
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

    security.polkit.enable = true;

    services.searx.enable = true;

    services.mihomo.enable = true;

    programs.chromium.enable = true;

    services.kmscon = {
      enable = true;
      config.font-size = 28;
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

    virtualisation.waydroid.enable = true;

    jovian.steam = {
      enable = true;
      autoStart = true;
    };
    jovian.hardware.has.amd.gpu = true;

    programs.niri.enable = true;
    jovian.steam.desktopSession = "niri-uwsm";
    hm.programs.niri.settings = {
      outputs."eDP-1".scale = 1.5;
    };
    hm.programs.uwsm.desktopEnv.niri = {
      QT_SCALE_FACTOR = "1.5";
    };

    programs.localsend = {
      enable = true;
      package = pkgs.gtk-nocsd.wrapper pkgs.localsend;
    };

    hm.programs.git.enable = true;

    hm.programs.vscodium.enable = true;

    hm.programs.aria2.enable = true;

    hm.programs.cava.enable = true;

    hm.programs.zathura.enable = true;

    hm.programs.swayimg.enable = true;

    hm.programs.yazi.enable = true;

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

    hm.programs.kew.enable = true;

    hm.programs.opencode.enable = true;

    hm.programs.fastfetch.enable = true;

    hm.programs.neovim.enable = true;

    hm.programs.gomi.enable = true;

    hm.programs.tlrc.enable = true;

    hm.programs.jq.enable = true;

    hm.programs.bottom.enable = true;

    hm.programs.atuin.enable = true;

    hm.programs.fd.enable = true;

    hm.programs.grep.enable = true;

    hm.programs.bat.enable = true;

    hm.programs.eza.enable = true;

    hm.programs.nix-index-database.enable = true;

    hm.programs.bash.enable = true;

    hm.programs.impala.enable = true;

    hm.programs.bluetui.enable = true;

    hm.xdg.desktopEntries.webcam = {
      name = "webcam";
      exec = "mpv av://v4l2:/dev/video0 --profile=low-latency --untimed";
    };

    hm.xdg.desktopEntries.libinput-debug-gui = {
      name = "libinput-debug-gui";
      exec = "libinput debug-gui";
    };

    hm.home.packages = with pkgs; [
      custom-scripts
      just
      nix-output-monitor
      nh
      nurl
      moreutils
      wget
      q
      yq-go
      tree
      wireplumber
      exiftool
      android-tools
      appimage-run
      xdg-user-dirs

      (gtk-nocsd.wrapper pwvucontrol)
      (gtk-nocsd.wrapper crosspipe)

      scrcpy

      telegram-desktop
      (gtk-nocsd.wrapper netease-cloud-music-gtk)

      (gtk-nocsd.wrapper gnome-mines)

      (libinput.override {eventGUISupport = true;})
    ];

    hm.games = {
      ksre.enable = true;
      minecraft.enable = true;
      # retroarch.enable = true;
      BD2.enable = true;

      steam.shortcuts."PVZRH" = {
        appname = "Plants vs. Zombies: RH";
        exe = "${pkgs.pvz-rh}/PlantsVsZombiesRH.exe";
      };

      steam.shortcuts.Waydroid = {
        exe = "waydroid-launcher";
      };
    };
  };
}
