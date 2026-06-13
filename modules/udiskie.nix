{
  flake.modules.homeManager.nixos = {
    osConfig,
    lib,
    ...
  }: {
    services.udiskie = lib.mkIf osConfig.services.udisks2.enable {
      enable = lib.mkDefault true;
    };
  };
}
