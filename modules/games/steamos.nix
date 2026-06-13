{inputs, ...}: {
  flake-file.inputs = {
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.jovian.nixosModules.default];

    jovian.steam = lib.mkIf config.jovian.steam.enable {
      user = config.user.name;
      environment.PROTON_USE_RAW_INPUT = "1";
    };
  };
}
