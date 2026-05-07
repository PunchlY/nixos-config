{
  config,
  inputs,
  ...
}: {
  flake.nixosModules.base = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      accept-flake-config = true;
      substituters = config.flake-file.nixConfig.substituters;
      trusted-public-keys = config.flake-file.nixConfig.trusted-public-keys;
      trusted-users = ["root" "@wheel"];
    };

    nix.registry.self.flake = inputs.self;
  };
}
