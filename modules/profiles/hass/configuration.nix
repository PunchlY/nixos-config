{self, ...}: {
  nixpkgs.config = {
    allowUnfreePackages = [
      "XiaoMi/xiaomi_home"
    ];
  };

  configurations.nixos.hass.module = {
    config,
    pkgs,
    ...
  }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true;

    services.openssh.enable = true;

    services.swapspace.enable = true;

    hardware.bluetooth.enable = true;

    networking.firewall = {
      allowedTCPPorts = [
        8123
      ];
    };

    sops.secrets.hass = {
      owner = "hass";
      path = "/var/lib/hass/secrets.yaml";

      format = "yaml";
      sopsFile = "${self}/secrets/hass.yaml";
      key = "";

      restartUnits = ["home-assistant.service"];
    };

    systemd.tmpfiles.rules = [
      "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/scripts.yaml 0755 hass hass"
      "f ${config.services.home-assistant.configDir}/homeassistant.yaml 0755 hass hass"
    ];

    services.home-assistant = {
      enable = true;
      customComponents = with pkgs; [
        midea-auto-cloud
        haier
        home-assistant-custom-components.xiaomi_home
      ];

      customLovelaceModules =
        (with pkgs.home-assistant-custom-lovelace-modules; [
          mushroom
        ])
        ++ (with pkgs; [
          nur.repos.mrene.timer-bar-card
        ]);

      themes = with pkgs.home-assistant-themes; [
        material-you-theme
      ];

      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "roborock"
        "bthome"
        "homekit"
        "ffmpeg"
        "zeroconf"
      ];
      config = {
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";

        default_config = {};
        "homeassistant ui" = "!include homeassistant.yaml";
        homeassistant = {
          external_url = "https://hass.punchly.eu.org";
          internal_url = "http://hass:8123/";

          name = "Home";
          unit_system = "metric";
          temperature_unit = "C";

          latitude = "!secret latitude";
          longitude = "!secret longitude";
          elevation = "!secret elevation";
          radius = 20;
        };
      };

      extraPackages = ps:
        with ps; [
          isal
          zlib-ng
          hap-python
          pyqrcode
          gtts
        ];
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    services.getty.autologinUser = config.user.name;
  };
}
