{
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options = {
        module = lib.mkOption {type = lib.types.deferredModule;};
      };
    });
  };

  config.flake.nixosConfigurations =
    lib.flip lib.mapAttrs config.configurations.nixos
    (hostName: {module, ...}:
      lib.nixosSystem {
        modules = [
          module
          {
            imports = [config.flake.modules.nixos.base];
            networking.hostName = hostName;
            system.stateVersion = "26.05";
          }
        ];
      });
}
