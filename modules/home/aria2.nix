{
  nixosConfig,
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
  systemd.user.tmpfiles.rules = lib.mkIf nixosConfig.services.aria2.enable [
    "L ${escapeTmpfiles "${config.xdg.userDirs.download}/aria2"} - - - - ${escapeTmpfiles nixosConfig.services.aria2.settings.dir}"
  ];
}
