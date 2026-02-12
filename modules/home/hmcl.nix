{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hmcl;
in
{
  options.programs.hmcl = {
    enable = lib.mkEnableOption "hmcl";

    package = lib.mkPackageOption pkgs "hmcl" { nullable = true; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    services.steam-shortcuts.shortcuts.hmcl = lib.mkIf config.services.steam-shortcuts.enable {
      appname = lib.mkDefault "HMCL";
      exe = lib.getExe cfg.package;
    };
  };
}
