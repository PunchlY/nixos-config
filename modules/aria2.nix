{lib, ...}: {
  flake.nixosModules.base = {
    config,
    pkgs,
    ...
  }: {
    user.extraGroups = ["aria2"];

    services.aria2 = lib.mkIf config.services.aria2.enable {
      openPorts = lib.mkDefault false;
      rpcSecretFile = lib.mkDefault (pkgs.writeText "secret" "aria2rpc");
    };
  };

  flake.homeModules.nixos = {
    osConfig,
    config,
    ...
  }: let
    escapeTmpfiles = lib.strings.escapeC [
      "\t"
      "\n"
      "\r"
      " "
      "\\"
    ];
  in {
    systemd.user.tmpfiles.rules = lib.mkIf osConfig.services.aria2.enable [
      "L ${escapeTmpfiles "${config.xdg.userDirs.download}/aria2"} - - - - ${escapeTmpfiles osConfig.services.aria2.settings.dir}"
    ];
  };
}
