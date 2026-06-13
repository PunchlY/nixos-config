{lib, ...}: {
  flake.modules.homeManager.nixos = {osConfig, ...}: {
    services.kdeconnect = lib.mkIf osConfig.programs.kdeconnect.enable {
      package = osConfig.programs.kdeconnect.package;
      enable = lib.mkDefault true;
      indicator = lib.mkDefault true;
    };
  };
}
