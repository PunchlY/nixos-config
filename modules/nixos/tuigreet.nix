{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.tuigreet;
in
{
  options.programs.tuigreet = {
    enable = lib.mkEnableOption "tuigreet";

    package = lib.mkPackageOption pkgs "tuigreet" { };
  };

  config = lib.mkIf cfg.enable {
    services.seatd.enable = true;

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = "${lib.getExe pkgs.tuigreet} ${
        lib.cli.toCommandLineShellGNU { } {
          sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
          session-wrapper = "${pkgs.execline}/bin/exec >/dev/null";
          time = true;
          time-format = "%H:%M";
          user-menu = true;
          remember = true;
          remember-session = true;
          asterisks = false;
        }
      }";
    };
  };
}
