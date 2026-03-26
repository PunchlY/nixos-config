{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.theme) colors;
in
{
  config = lib.mkIf config.programs.chromium.enable {
    programs.chromium = {
      extraOpts = {
        BrowserThemeColor = colors.surface.hex;
        DefaultBrowserSettingEnabled = false;
        OsColorMode = "dark";
      };
    };
  };
}
