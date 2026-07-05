{
  configurations.nixos.nixos.module = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

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

    services.mihomo.enable = true;

    jovian.steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gamescope-wayland";
    };

    hm.programs.prismlauncher.enable = true;
  };
}
