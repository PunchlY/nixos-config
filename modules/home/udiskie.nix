{
  nixosConfig,
  config,
  lib,
  ...
}: {
  services.kdeconnect = lib.mkIf nixosConfig.services.udisks2.enable {
    enable = lib.mkDefault true;
  };
}
