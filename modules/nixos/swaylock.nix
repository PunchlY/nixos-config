{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.swaylock;
in {
  options.services.swaylock = {
    enable = lib.mkEnableOption "swaylock";
    package = lib.mkPackageOption pkgs "swaylock" {};
  };

  config = lib.mkIf config.services.swaylock.enable {
    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    services.systemd-lock-handler.enable = true;

    systemd.user.services.swaylock = {
      onSuccess = ["unlock.target"];
      partOf = ["lock.target"];
      before = ["lock.target"];
      wantedBy = ["lock.target"];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${lib.getExe cfg.package} -f";
        Restart = "on-failure";
        RestartSec = 0;
      };
    };

    home-manager.sharedModules = lib.singleton {
      programs.swaylock = {
        enable = true;
        package = lib.mkDefault null;
      };
    };
  };
}
