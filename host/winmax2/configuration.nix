{ config, pkgs, ... }:

{
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

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  system.stateVersion = "26.05";

  services.openssh.enable = true;

  services.udisks2.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.kdeconnect.enable = true;

  services.swapspace.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.logind.settings.Login = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
  };

  services.dbus.enable = true;

  services.unblockneteasemusic.enable = true;

  hardware.bluetooth.enable = true;

  services.aria2.enable = true;

  services.nginx.enable = true;

  security.polkit.enable = true;

  services.searx.enable = true;

  services.mihomo.enable = true;

  hardware.graphics.enable = true;

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

  programs.wshowkeys.enable = true;

  jovian.steam.enable = true;

  services.seatd.enable = true;

  programs.tuigreet.enable = true;
}
