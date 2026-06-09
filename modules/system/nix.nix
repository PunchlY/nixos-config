{
  config,
  inputs,
  ...
}: {
  flake-file.nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    extra-experimental-features = [
      # "pipe-operators"
    ];
  };

  flake.nixosModules.base = {
    nix.settings = {
      experimental-features = config.flake-file.nixConfig.experimental-features or [];
      accept-flake-config = true;
      substituters = config.flake-file.nixConfig.substituters or [];
      trusted-public-keys = config.flake-file.nixConfig.trusted-public-keys or [];
      trusted-users = ["root" "@wheel"];
    };

    nix.registry.self.flake = inputs.self;
  };
}
