{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.programs.gomi;
  in {
    options.programs.gomi = {
      enable = lib.mkEnableOption "gomi";
      package = lib.mkPackageOption pkgs "gomi" {nullable = true;};
    };
    config = {
      home.packages = lib.mkIf (cfg.package != null) [cfg.package];
      home.shellAliases.rm = "gomi";
    };
  };
}
