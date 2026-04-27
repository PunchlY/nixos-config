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
    nixosConfig,
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
    systemd.user.tmpfiles.rules = lib.mkIf nixosConfig.services.aria2.enable [
      "L ${escapeTmpfiles "${config.xdg.userDirs.download}/aria2"} - - - - ${escapeTmpfiles nixosConfig.services.aria2.settings.dir}"
    ];
  };
}
