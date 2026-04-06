{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.theme) wallpaper;
  cfg = config.programs.niri;
in {
  config = lib.mkIf cfg.enable {
    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri --session";
        };
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    programs.niri.useNautilus = lib.mkDefault false;

    systemd.user.services.niri-flake-polkit = {
      after = ["wayland-wm@niri.service"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.fuzzel-polkit-agent}/libexec/fuzzel-polkit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    systemd.user.services.niri-wallpaper = {
      after = ["wayland-wm@niri.service"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.wbg} --stretch ${wallpaper}";
        Restart = "on-failure";
      };
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
    };
  };
}
