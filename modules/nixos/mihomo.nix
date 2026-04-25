{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.services.mihomo;

  format = pkgs.formats.yaml {};
in {
  options.services.mihomo = {
    setting = lib.mkOption {
      type = format.type;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.mihomo.file = inputs.self.outPath + "/secrets/mihomo.age";

    networking.firewall.trustedInterfaces = ["mihomo0"];
    networking.firewall.checkReversePath = false;

    systemd.services.mihomo.wantedBy = lib.mkForce [];

    systemd.services.mihomo = {
      serviceConfig = {
        ExecStart = lib.mkForce (lib.concatStringsSep " " [
          (lib.getExe cfg.package)
          "-d /var/lib/private/mihomo"
          "-f /var/lib/private/mihomo/config.yaml"
          (lib.optionalString (cfg.webui != null) "-ext-ui ${cfg.webui}")
          (lib.optionalString (cfg.extraOpts != null) cfg.extraOpts)
        ]);
        ExecStartPre = pkgs.writeShellScript "config-merge" ''
          ${pkgs.yq-go}/bin/yq eval-all \
            'select(fileIndex==0) * select(fileIndex==1)' \
            - "$CREDENTIALS_DIRECTORY/config.yaml" \
            > /var/lib/private/mihomo/config.yaml \
            <${format.generate "setting.yaml" config.services.mihomo.setting}
        '';
      };
    };

    services.mihomo = {
      webui = pkgs.metacubexd;
      tunMode = true;
      processesInfo = true;
      configFile = config.age.secrets.mihomo.path;
      setting = {
        external-controller = "[::]:9090";
        ipv6 = true;
        mode = "rule";
        global-client-fingerprint = "chrome";
        profile = {
          store-fake-ip = true;
          store-selected = true;
        };

        tun = {
          enable = true;
          stack = "mixed";
          device = "mihomo0";
          dns-hijack = ["tcp://any:53" "udp://any:53"];
          auto-detect-interface = true;
          auto-redirect = true;
          auto-route = true;
        };

        geodata-mode = true;
        geodata-loader = "standard";
        geo-auto-update = true;
        geo-update-interval = 86400;
        geox-url = {
          asn = "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb";
          geoip = "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat";
          geosite = "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat";
        };

        proxy-groups = [
          {
            name = "PROXY";
            type = "select";
            proxies = [
              "AUTO"
              "JAPAN"
              "HONGKONG"
              "AMERICA"
              "DIRECT"
              "REJECT"
            ];
            include-all = true;
          }
          {
            name = "GAME";
            type = "select";
            proxies = [
              "DIRECT"
              "JAPAN"
              "HONGKONG"
              "AMERICA"
              "REJECT"
            ];
            include-all = true;
          }
          {
            name = "DOWNLOAD";
            type = "select";
            proxies = ["DOWNLOAD-TEST" "PROXY"];
          }
          {
            name = "DOWNLOAD-TEST";
            type = "url-test";
            include-all = true;
            filter = "下载专用";
            url = "https://www.gstatic.com/generate_204";
            interval = 300;
          }
          {
            name = "AUTO";
            type = "url-test";
            include-all = true;
            exclude-filter = "下载专用";
            url = "https://www.gstatic.com/generate_204";
            interval = 300;
          }
          {
            name = "JAPAN";
            type = "url-test";
            include-all = true;
            exclude-filter = "下载专用";
            filter = "日本";
            url = "https://www.gstatic.com/generate_204";
            interval = 300;
          }
          {
            type = "url-test";
            name = "HONGKONG";
            include-all = true;
            exclude-filter = "下载专用";
            filter = "香港";
            url = "https://www.gstatic.com/generate_204";
            interval = 300;
          }
          {
            name = "AMERICA";
            type = "url-test";
            include-all = true;
            exclude-filter = "下载专用";
            filter = "美国";
            url = "https://www.gstatic.com/generate_204";
            interval = 300;
          }
        ];

        rule-providers = {
          download_domainset = {
            behavior = "domain";
            type = "http";
            url = "https://ruleset.skk.moe/Clash/domainset/download.txt";
            format = "text";
            interval = 86400;
          };
          download = {
            behavior = "domain";
            type = "inline";
            payload = [
              "raw.githubusercontent.com"
              "cache.nixos.org"
              "*.cachix.org"
            ];
          };
          proxy = {
            behavior = "domain";
            type = "inline";
            payload = ["bgm.tv"];
          };
        };

        dns = {
          enable = true;
          ipv6 = true;
          respect-rules = true;
          enhanced-mode = "redir-host";
          default-nameserver = ["223.5.5.5"];
          direct-nameserver = ["https://223.5.5.5/dns-query"];
          listen = "[::]:1053";
          nameserver = ["https://223.5.5.5/dns-query"];
          nameserver-policy = {
            "geosite:category-ads-all" = ["rcode://name_error"];
            "geosite:gfw" = ["https://1.1.1.1/dns-query#disable-ipv6=true"];
            "geosite:private,category-pt,category-public-tracker,tracker" = ["https://223.5.5.5/dns-query"];
          };
          proxy-server-nameserver = ["223.5.5.5"];
        };

        rules = [
          "DST-PORT,21/22/25,DIRECT"
          "IP-CIDR,8.8.8.8/32,PROXY,no_resolve"
          "IP-CIDR,1.1.1.1/32,PROXY,no_resolve"

          "GEOSITE,category-ads-all,REJECT"
          "GEOSITE,private,DIRECT"
          "GEOSITE,category-pt,DIRECT"
          "GEOSITE,category-public-tracker,DIRECT"
          "GEOSITE,tracker,DIRECT"
          "GEOSITE,onedrive,DIRECT"
          "GEOSITE,microsoft@cn,DIRECT"
          "GEOSITE,apple-cn,DIRECT"
          "GEOSITE,steam@cn,GAME"
          "GEOSITE,category-games@cn,GAME"
          "GEOSITE,cn,DIRECT"
          "RULE-SET,download_domainset,DOWNLOAD"
          "RULE-SET,download,DOWNLOAD"
          "RULE-SET,proxy,PROXY"
          "GEOSITE,gfw,PROXY"

          "GEOIP,private,DIRECT,no-resolve"
          "GEOIP,cn,DIRECT,no-resolve"
          "GEOIP,google,PROXY"
          "GEOIP,telegram,PROXY"
          "GEOIP,netflix,PROXY"
          "GEOIP,facebook,PROXY"

          "MATCH,DIRECT"
        ];
      };
    };
  };
}
