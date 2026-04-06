{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.networkmanager = lib.mkIf config.networking.networkmanager.enable {
    wifi.backend = "iwd";
    wifi.powersave = false;
  };

  networking.nftables.enable = lib.mkDefault true;

  networking.firewall = {
    enable = lib.mkDefault true;
    allowedUDPPorts = [1900];
    extraInputRules = ''
      udp sport 1900 accept
    '';
  };

  networking.hosts = {
    "0.0.0.0" = [
      "overseauspider.yuanshen.com"
      "log-upload-os.hoyoverse.com"
      "log-upload-os.mihoyo.com"
      "dump.gamesafe.qq.com"

      "apm-log-upload-os.hoyoverse.com"
      "zzz-log-upload-os.hoyoverse.com"

      "log-upload.mihoyo.com"
      "devlog-upload.mihoyo.com"
      "uspider.yuanshen.com"
      "sg-public-data-api.hoyoverse.com"
      "hkrpg-log-upload-os.hoyoverse.com"
      "public-data-api.mihoyo.com"

      "prd-lender.cdp.internal.unity3d.com"
      "thind-prd-knob.data.ie.unity3d.com"
      "thind-gke-usc.prd.data.corp.unity3d.com"
      "cdp.cloud.unity3d.com"
      "remote-config-proxy-prd.uca.cloud.unity3d.com"

      "pc.crashsight.wetest.net"
    ];
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
