{inputs, ...}: {
  flake-file.inputs = {
    tldr-pages = {
      url = "github:tldr-pages/tldr";
      flake = false;
    };
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.tlrc;
    format = pkgs.formats.toml {};
  in {
    options.programs.tlrc = {
      enable = lib.mkEnableOption "tlrc";

      package = lib.mkPackageOption pkgs "tlrc" {nullable = true;};

      settings = lib.mkOption {
        type = format.type;
        default = {};
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = lib.mkIf (cfg.package != null) [cfg.package];

      xdg.configFile."tlrc/config.toml" = lib.mkIf (cfg.settings != {}) {
        source = format.generate "config.toml" cfg.settings;
      };

      programs.tlrc.settings = {
        cache = {
          dir = inputs.tldr-pages.outPath;
          mirror = "";
          auto_update = false;
        };
      };
    };
  };
}
