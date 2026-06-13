{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.boot.plymouth.enable {
      boot.kernelParams = [
        "quiet"
        "splash"
        "udev.log_level=3"
        "systemd.show_status=auto"
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
