{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.impala;
  in {
    options.programs.impala = {
      enable = lib.mkEnableOption "impala";

      package = lib.mkPackageOption pkgs "impala" {nullable = true;};
    };

    config = lib.mkIf cfg.enable {
      home.packages = lib.mkIf (cfg.package != null) [cfg.package];

      xdg.desktopEntries.impala = {
        name = "Impala";
        genericName = "Wifi Manager";
        exec = "impala";
        terminal = true;
      };
    };
  };
}
