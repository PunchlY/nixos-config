{lib, ...}: {
  flake.modules.nixos.base = {
    config,
    pkgs,
    utils,
    ...
  }: {
    config = lib.mkIf config.programs.niri.enable {
      security = {
        polkit.enable = true;
        pam.services.swaylock = {};
      };

      services.systemd-lock-handler.enable = true;

      systemd.user.services.niri-lock = {
        requisite = ["graphical-session.target"];
        after = ["wayland-wm@niri.service"];
        onSuccess = ["unlock.target"];
        partOf = ["lock.target"];
        before = ["lock.target"];
        wantedBy = ["lock.target"];
        serviceConfig = {
          Type = "forking";
          ExecStart = utils.escapeSystemdExecArgs [
            (lib.getExe pkgs.swaylock-effects)
            "--daemonize"
            "--clock"
            "--indicator"
            "--timestr=%H:%M:%S"
            "--datestr=%Y-%m-%d"
          ];
          Restart = "on-failure";
          RestartSec = 0;
        };
      };
    };
  };

  flake.modules.homeManager.nixos = {osConfig, ...}: {
    config = lib.mkIf osConfig.programs.niri.enable {
      programs.swaylock = {
        enable = true;
        package = null;
      };
      programs.niri.settings.binds."Mod+Alt+L" = {
        hotkey-overlay.title = "Lock the Screen";
        allow-inhibiting = false;
        action.spawn-sh = "loginctl lock-session";
      };
    };
  };
}
