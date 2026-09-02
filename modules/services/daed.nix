{
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    utils,
    ...
  }: let
    cfg = config.services.daed;
  in {
    options.services.daed = {
      enable = lib.mkEnableOption "daed";

      package = lib.mkPackageOption pkgs "daed" {};

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 2023;
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "[::]";
      };

      apiOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    config = lib.mkIf cfg.enable {
      networking = lib.mkIf cfg.openFirewall {
        firewall.allowedTCPPorts = [cfg.port];
      };
      environment.etc."daed/geoip.dat".source = "${pkgs.v2ray-geoip}/share/v2ray/geoip.dat";
      environment.etc."daed/geosite.dat".source = "${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat";
      systemd.services.daed = {
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = utils.escapeSystemdExecArgs (
            [(lib.getExe cfg.package) "run"]
            ++ lib.cli.toCommandLineGNU {} {
              disable-timestamp = true;
              config = "/etc/daed";
              listen = "${cfg.address}:${toString cfg.port}";
              api-only = cfg.apiOnly;
            }
          );
        };
      };
    };
  };
}
