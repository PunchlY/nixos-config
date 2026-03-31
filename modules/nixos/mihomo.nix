{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.services.mihomo.enable {
    age.secrets.mihomo.file = inputs.self.outPath + "/secrets/mihomo.age";

    networking.firewall.trustedInterfaces = [ "mihomo0" ];
    networking.firewall.checkReversePath = false;

    systemd.services.mihomo.wantedBy = lib.mkForce [ ];

    services.mihomo = {
      tunMode = true;
      configFile = config.age.secrets.mihomo.path;
    };
  };
}
