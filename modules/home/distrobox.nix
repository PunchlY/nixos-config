{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.distrobox = lib.mkIf config.programs.distrobox.enable {
    settings.container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
  };
}
