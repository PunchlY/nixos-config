{lib, ...}: {
  flake.homeModules.nixos = {osConfig, ...}: {
    services.udiskie = lib.mkIf osConfig.services.udisks2.enable {
      enable = lib.mkDefault true;
    };
  };
}
