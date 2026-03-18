{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  config = lib.mkIf config.services.mihomo.enable {
    age.secrets.mihomo.file = self.outPath + "/secrets/mihomo.age";

    networking.firewall.trustedInterfaces = [ "mihomo0" ];
    networking.firewall.checkReversePath = false;

    systemd.services.mihomo.wantedBy = lib.mkForce [ ];

    services.mihomo = {
      tunMode = true;
      configFile = config.age.secrets.mihomo.path;
    };
  };
}
