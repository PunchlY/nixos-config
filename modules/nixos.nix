{
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options = {
        module = lib.mkOption {type = lib.types.deferredModule;};
        enableTheme = lib.mkEnableOption "theme";
      };
    });
  };

  config.flake.nixosConfigurations =
    lib.flip lib.mapAttrs config.configurations.nixos
    (hostName: opts @ {module, ...}:
      lib.nixosSystem {
        specialArgs = {
          inherit (opts) enableTheme;
        };
        modules = [
          module
          {
            imports = [
              config.flake.nixosModules.base
            ];
            networking.hostName = hostName;
            system.stateVersion = "26.05";
          }
        ];
      });
}
