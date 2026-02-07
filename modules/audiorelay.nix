{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.audiorelay;
in
{
  options.programs.audiorelay = {
    enable = lib.mkEnableOption "audiorelay";

    package = lib.mkPackageOption pkgs "audiorelay" { nullable = true; };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf (cfg.package != null) [ cfg.package ];

    services.pipewire.extraConfig.pipewire = {
      "10-audiorelay-virtual-speaker-sink" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Audio-Relay-Speaker";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
                "stream.dont-remix" = true;
                "node.name" = "audiorelay-speaker";
              };
            };
          }
        ];
      };
      "10-audiorelay-virtual-mic-sink" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Audio-Relay-Mic";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
                "stream.dont-remix" = true;
                "node.name" = "audiorelay-mic-sink";
              };

              "playback.props" = {
                "media.class" = "Audio/Source";
                "audio.position" = [
                  "FL"
                  "FR"
                ];
                "target.object" = "audiorelay-mic-sink";
                "node.name" = "audiorelay-mic";
              };
            };
          }
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [
      59100
      59200
      59716
    ];
    networking.firewall.allowedUDPPorts = [
      59100
      59200
      59716
    ];
  };
}
