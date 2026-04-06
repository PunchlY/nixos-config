{
  nixosConfig,
  lib,
  ...
}: {
  services.kdeconnect = lib.mkIf nixosConfig.programs.kdeconnect.enable {
    package = nixosConfig.programs.kdeconnect.package;
    enable = lib.mkDefault true;
    indicator = lib.mkDefault true;
  };
}
