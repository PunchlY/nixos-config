{
  nixpkgs.config = {
    allowUnfreePackages = [
      "aseprite"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.aseprite;
  in {
    options.programs.aseprite = {
      enable = lib.mkEnableOption "Aseprite";

      package = lib.mkPackageOption pkgs "aseprite" {};
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];
    };
  };
}
