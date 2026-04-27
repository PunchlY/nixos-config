{lib, ...}: {
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.swaylock;
  in {
    options.services.swaylock = {
      enable = lib.mkEnableOption "swaylock";
      package = lib.mkPackageOption pkgs "swaylock" {};
    };

    config = lib.mkIf cfg.enable {
      security = {
        polkit.enable = true;
        pam.services.swaylock = {};
      };

      services.systemd-lock-handler.enable = true;

      systemd.user.services.swaylock = {
        requisite = ["graphical-session.target"];
        after = ["graphical-session.target"];
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
    };
  };

  flake.modules.homeManager.nixos = {nixosConfig, ...}: let
    inherit (nixosConfig.theme) colors wallpaper;
  in {
    config = lib.mkIf nixosConfig.services.swaylock.enable {
      programs.swaylock = {
        enable = true;
        package = null;
        settings = with colors; {
          image = "${wallpaper}";

          color = background.hex_stripped;
          inside-color = surface_container.hex_stripped;
          inside-clear-color = secondary_container.hex_stripped;
          inside-ver-color = primary_container.hex_stripped;
          inside-wrong-color = error_container.hex_stripped;
          inside-caps-lock-color = orange.hex_stripped;
          ring-color = primary.hex_stripped;
          ring-clear-color = secondary.hex_stripped;
          ring-ver-color = primary.hex_stripped;
          ring-wrong-color = error.hex_stripped;
          ring-caps-lock-color = orange.hex_stripped;
          text-color = on_background.hex_stripped;
          text-clear-color = on_secondary_container.hex_stripped;
          text-ver-color = on_primary_container.hex_stripped;
          text-wrong-color = on_error_container.hex_stripped;
          text-caps-lock-color = on_orange.hex_stripped;
          key-hl-color = cyan.hex_stripped;
          layout-bg-color = surface_container_low.hex_stripped;
          layout-border-color = outline_variant.hex_stripped;
          layout-text-color = on_surface_variant.hex_stripped;
          separator-color = "00000000";
          line-uses-inside = true;
        };
      };
    };
  };
}
