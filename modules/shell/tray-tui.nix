{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.tray-tui;
  in {
    config = lib.mkIf cfg.enable {
      programs.tray-tui.settings = {
        columns = 1;
      };

      xdg.desktopEntries.tray-tui = {
        name = "Tray";
        genericName = "System tray in your terminal";
        exec = "tray-tui";
        terminal = true;
      };
    };
  };
}
