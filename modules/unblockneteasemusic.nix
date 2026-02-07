{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.unblockneteasemusic;
in
{
  options.services.unblockneteasemusic = {
    enable = lib.mkEnableOption "UnblockNeteaseMusic service";
    port = {
      http = lib.mkOption {
        type = lib.types.int;
        default = 5200;
      };
      https = lib.mkOption {
        type = lib.types.int;
        default = 5201;
      };
    };
    environment = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            str
            path
            package
          ])
        );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.unblockneteasemusic = {
      after = [ "network.target" ];
      environment = cfg.environment;
      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe pkgs.unblockneteasemusic)
          "-p"
          "${toString cfg.port.http}:${toString cfg.port.https}"
          "-a"
          "127.0.0.1"
          "-f"
          "112.83.164.101"
        ];
        StandardOutput = "journal";
        DynamicUser = true;
      };
      unitConfig.StopWhenUnneeded = true;
    };
    systemd.sockets.unblockneteasemusic-proxy = {
      listenStreams = [ "/run/unblockneteasemusic.sock" ];
      wantedBy = [ "sockets.target" ];
    };
    systemd.services.unblockneteasemusic-proxy = {
      requires = [
        "unblockneteasemusic.service"
        "unblockneteasemusic-proxy.socket"
      ];
      after = [
        "unblockneteasemusic.service"
        "unblockneteasemusic-proxy.socket"
      ];
      environment = cfg.environment;
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=10m 127.0.0.1:${toString cfg.port.https}";
      };
    };

    security.pki.certificateFiles = [ "${pkgs.unblockneteasemusic}/server.crt" ];

    networking.hosts = lib.mkIf config.services.nginx.enable {
      "127.0.0.1" = [
        "music.163.com"
        "interface.music.163.com"
        "interface3.music.163.com"
        "apm.music.163.com"
        "apm3.music.163.com"
        "interface.music.163.com.163jiasu.com"
        "interface3.music.163.com.163jiasu.com"
      ];
    };

    services.nginx = lib.mkIf config.services.nginx.enable {
      virtualHosts."music.163.com" = {
        serverAliases = [
          "interface.music.163.com"
          "interface3.music.163.com"
          "apm.music.163.com"
          "apm3.music.163.com"
          "interface.music.163.com.163jiasu.com"
          "interface3.music.163.com.163jiasu.com"
        ];
        sslCertificate = "${pkgs.unblockneteasemusic}/server.crt";
        sslCertificateKey = "${pkgs.unblockneteasemusic}/server.key";
        forceSSL = true;

        locations."/".proxyPass = "https://unix:/run/unblockneteasemusic.sock:";
        # locations."/".proxyPass = "http://127.0.0.1:3000";
        extraConfig = ''
          proxy_set_header HOST $host;
        '';
      };
    };

  };
}
