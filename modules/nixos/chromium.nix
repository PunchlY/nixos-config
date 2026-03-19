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
        BrowserThemeColor = colors.hex.surface;
        DefaultBrowserSettingEnabled = false;
        OsColorMode = "dark";
      };
    };
  };
}
