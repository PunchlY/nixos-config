{
  configurations.nixos.tap.module = {pkgs, ...}: {
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.plymouth.enable = true;

    networking.networkmanager.enable = true;

    services.openssh.enable = true;

    services.udisks2.enable = true;

    services.pipewire.enable = true;

    services.swapspace.enable = true;

    services.dbus.enable = true;

    hardware.bluetooth.enable = true;

    security.polkit.enable = true;

    services.waydroid-nvidia.enable = true;

    jovian.steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gamescope-wayland";
    };
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';

    hm.programs.wiliwili.enable = true;

    hm.programs.prismlauncher.enable = true;

    hm.programs.celeste64.enable = true;

    hm.programs.shattered-pixel-dungeon.enable = true;

    hm.programs.steam.config = {
      nonSteamApps."Brown Dust 2".enable = true;

      apps.Balatro.enable = true;

      apps.Helltaker.enable = true;

      nonSteamApps.Waydroid.enable = true;
    };
  };
}
