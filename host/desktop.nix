{
  lib,
  config,
  pkgs,
  ...
}:

{
  hardware.graphics.enable = true;

  programs.niri = {
    enable = true;
    useNautilus = false;
  };
  # security.pam.services.waylock = { };

  programs.localsend = {
    enable = false;
    package = pkgs.gtk-nocsd.wrapper pkgs.localsend;
  };

  programs.wshowkeys = {
    enable = false;
    package = pkgs.wshowkeys-symbols;
  };

  jovian.steam = {
    enable = true;
    environment = {
      PROTON_USE_RAW_INPUT = "1";
    };
  };
  jovian.decky-loader = {
    enable = false;
    extraPackages = with pkgs; [
      coreutils
      systemd
      python3
      steam
    ];
  };

  services.seatd.enable = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} ${
      lib.cli.toCommandLineShellGNU { } {
        sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        session-wrapper = "${pkgs.execline}/bin/exec > /dev/null";
        time = true;
        time-format = "%H:%M";
        user-menu = true;
        remember = true;
        remember-session = true;
        asterisks = false;
      }
    }";
  };
}
