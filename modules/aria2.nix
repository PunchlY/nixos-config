{
  flake.modules.nixos.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    user.extraGroups = ["aria2"];

    services.aria2 = lib.mkIf config.services.aria2.enable {
      openPorts = lib.mkDefault false;
      rpcSecretFile = lib.mkDefault (pkgs.writeText "secret" "aria2rpc");
    };
  };

  flake.modules.homeManager.nixos = {
    osConfig,
    config,
    lib,
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
