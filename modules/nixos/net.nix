{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.networkmanager = lib.mkIf config.networking.networkmanager.enable {
    wifi.backend = "iwd";
    wifi.powersave = false;
  };

  networking.nftables.enable = lib.mkDefault true;

  networking.firewall = {
    enable = lib.mkDefault true;
    allowedUDPPorts = [ 1900 ];
    extraInputRules = ''
      udp sport 1900 accept
    '';
  };

  services.nginx = lib.mkIf config.services.nginx.enable {
    virtualHosts.localhost = {
      default = true;
      rejectSSL = true;
      extraConfig = "return 444;";
    };
  };

  services.aria2 = lib.mkIf config.services.aria2.enable {
    openPorts = lib.mkDefault false;
    rpcSecretFile = lib.mkDefault (pkgs.writeText "secret" "aria2rpc");
  };
}
