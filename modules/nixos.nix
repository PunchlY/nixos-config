{
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule ({name, ...}: {
      options = {
        hostName = lib.mkOption {
          type = lib.types.str;
          default = name;
        };
        module = lib.mkOption {type = lib.types.deferredModule;};
        theme = {
          enable = lib.mkEnableOption "theme";
          wallpaper = lib.mkOption {
            type = lib.types.unspecified;
          };
        };
      };
    }));
  };

  config.flake.nixosConfigurations =
    lib.flip lib.mapAttrs config.configurations.nixos
    (_: cfg:
      lib.nixosSystem {
        modules =
          [
            cfg.module
            config.flake.nixosModules.base
            {
              networking.hostName = cfg.hostName;
              system.stateVersion = "26.05";
            }
          ]
          ++ lib.optionals cfg.theme.enable [
            config.flake.nixosModules.theme
            ({pkgs, ...}: {
              theme.wallpaper =
                if builtins.isFunction cfg.theme.wallpaper
                then pkgs.callPackage cfg.theme.wallpaper {}
                else cfg.theme.wallpaper;
            })
          ];
      });
}
