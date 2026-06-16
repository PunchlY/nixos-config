{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.bluetui;
  in {
    options.programs.bluetui = {
      enable = lib.mkEnableOption "bluetui";

      package = lib.mkPackageOption pkgs "bluetui" {nullable = true;};
    };

    config = lib.mkIf cfg.enable {
      home.packages = lib.mkIf (cfg.package != null) [cfg.package];

      xdg.desktopEntries.bluetui = {
        name = "Bluetui";
        genericName = "Bluetooth Manager";
        exec = "bluetui";
        terminal = true;
      };
    };
  };
}
