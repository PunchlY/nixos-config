{
  config,
  pkgs,
  lib,
  jovian,
  ...
}:
{
  imports = [
    jovian.nixosModules.default
  ];

  systemd.user.tmpfiles.rules = lib.mkIf config.jovian.decky-loader.enable [
    # Enable CEF remote debugging
    "f %h/.local/share/Steam/.cef-enable-remote-debugging 0644 - - -"
  ];

  jovian.steam.environment.PROTON_USE_RAW_INPUT = "1";

}
