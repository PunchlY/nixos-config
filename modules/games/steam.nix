{inputs, ...}: {
  flake-file.inputs = {
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
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

  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.steam-config-nix.homeModules.default];

    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      onSteamRunning = "close";
    };
  };
}
