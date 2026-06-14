{
  configurations.nixos.ha-server.module = {
    config,
    pkgs,
    ...
  }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    services.openssh.enable = true;

    services.udisks2.enable = true;

    services.pipewire.enable = true;

    services.swapspace.enable = true;

    hardware.bluetooth.enable = true;

    security.polkit.enable = true;

    services.home-assistant = {
      enable = true;
      config = {
        homeassistant = {
          external_url = "https://hass.punchly.eu.org";
          internal_url = "http://ha-server:8123";
        };
      };
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    services.getty.autologinUser = config.user.name;
  };
}
