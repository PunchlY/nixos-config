{lib, ...}: {
  flake.homeModules.theme = {
    nixosConfig,
    config,
    pkgs,
    ...
  }: let
    inherit (nixosConfig.theme) wallpaper;
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
