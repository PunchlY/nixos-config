{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.vscodium.profiles.default = lib.mkIf config.programs.vscodium.enable {
      userSettings = {
        "js/ts.tsdk.path" = pkgs.bun-types.tsdk.path;
        "js/ts.implicitProjectConfig.target" = "ESNext";
      };
    };
  };
}
