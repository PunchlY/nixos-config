{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.theme) wallpaper;
  cfg = config.programs.niri;
in {
  disabledModules = ["programs/wayland/niri.nix"];

  options.programs.niri = {
    enable = lib.mkEnableOption "Niri, a scrollable-tiling Wayland compositor";

    package = lib.mkPackageOption pkgs "niri" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    programs.uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri";
        extraArgs = ["--session"];
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];

      config.niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };

    services.gnome.gnome-keyring.enable = true;

    services.graphical-desktop.enable = true;

    security.polkit.enable = true;

    security.pam.services.swaylock = {};

    programs.dconf.enable = true;

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
