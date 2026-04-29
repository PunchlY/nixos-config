{lib, ...}: {
  flake.homeModules.nixos = {osConfig, ...}: {
    services.kdeconnect = lib.mkIf osConfig.services.udisks2.enable {
      enable = lib.mkDefault true;
    };
  };
}
