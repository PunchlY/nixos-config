{lib, ...}: {
  flake.modules.homeManager.nixos = {nixosConfig, ...}: {
    services.kdeconnect = lib.mkIf nixosConfig.services.udisks2.enable {
      enable = lib.mkDefault true;
    };
  };
}
