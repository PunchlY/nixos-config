{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    seamless-asahi-plymouth = {
      url = "github:luca-schlecker/seamless-asahi-plymouth";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.nixosModules.base = {
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.boot.plymouth.enable {
      boot.plymouth = {
        theme = "seamless-asahi";
        themePackages = [inputs.seamless-asahi-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default];
      };

      boot.kernelParams = [
        "quiet"
        "splash"

        "udev.log_level=3"
        "rd.udev.log_level=3"

        "systemd.show_status=auto"
        "rd.systemd.show_status=auto"

        # "vt.global_cursor_default=0"

        "plymouth.use-simpledrm"
      ];
      boot.consoleLogLevel = 3;
      boot.initrd.verbose = false;
      boot.loader.timeout = 0;
    };
  };

  flake.nixosModules.theme = {config, ...}: let
    inherit (config.theme) font;
  in {
    config = lib.mkIf config.boot.plymouth.enable {
      boot.plymouth = {
        font = font.path;
      };
    };
  };
}
