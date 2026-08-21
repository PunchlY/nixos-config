{moduleWithSystem, ...}: {
  flake-file.inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.homeManager.base = moduleWithSystem ({inputs'}: {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.nix-index-database;
  in {
    options.programs.nix-index-database = {
      enable = lib.mkEnableOption "nix-index-database";
    };
    config = lib.mkIf cfg.enable {
      home.packages = [
        inputs'.nix-index-database.packages.comma-with-db
      ];

      programs.nix-index = {
        enable = lib.mkDefault true;
        package = inputs'.nix-index-database.packages.nix-index-with-db;
        enableBashIntegration = false;
        enableZshIntegration = false;
        enableFishIntegration = false;
        enableNushellIntegration = false;
      };

      xdg.configFile."nix-index/files".source = inputs'.nix-index-database.packages.nix-index-database;
    };
  });
}
