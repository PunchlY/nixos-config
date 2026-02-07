{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.theme) wallpaper;
in
{
  systemd.user.services.wbg = {
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "wbg";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.wbg} --stretch ${wallpaper.adaptive-blur}";
      Restart = "always";
      RestartSec = "10";
    };
  };
}
