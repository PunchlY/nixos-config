{
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.base = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.home-assistant;
  in {
    config = lib.mkIf cfg.enable {
      sops.secrets.hass = {
        owner = "hass";
        path = "/var/lib/hass/secrets.yaml";

        format = "yaml";
        sopsFile = "${inputs.self}/secrets/hass.yaml";
        key = "";

        restartUnits = ["home-assistant.service"];
      };

      systemd.tmpfiles.rules = [
        "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
        "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
        "f ${config.services.home-assistant.configDir}/scripts.yaml 0755 hass hass"
      ];

      services.home-assistant = {
        openFirewall = true;
        customComponents = with pkgs; [
          midea-auto-cloud
          haier
        ];

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
        ];
        config = {
          "automation ui" = "!include automations.yaml";
          "scene ui" = "!include scenes.yaml";
          "script ui" = "!include scripts.yaml";

          default_config = {};
          homeassistant = {
            name = "Home";
            unit_system = "metric";
            time_zone = config.time.timeZone;

            latitude = "!secret latitude";
            longitude = "!secret longitude";
            elevation = "!secret elevation";
            radius = 20;
          };
          http = {
            use_x_forwarded_for = true;
            trusted_proxies = [
              "127.0.0.0/8"
              "10.0.0.0/8"
              "172.16.0.0/12"
              "192.168.0.0/16"
            ];
          };
        };

        extraPackages = ps:
          with ps; [
            hap-python
            pyqrcode
            gtts
          ];
      };
    };
  };
}
