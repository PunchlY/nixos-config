{
  flake.modules.homeManager.theme = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.theme) wallpaper;
  in {
    config = lib.mkIf config.programs.niri.enable {
      programs.niri.settings.spawn-at-startup = [
        {
          argv = [(lib.getExe pkgs.wbg) "--stretch" (toString wallpaper)];
        }
      ];
      programs.niri.settings.layer-rules = [
        {
          matches = [{namespace = "^wallpaper$";}];
          place-within-backdrop = true;
        }
      ];
    };
  };
}
