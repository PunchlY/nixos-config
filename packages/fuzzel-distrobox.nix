{
  writeShellApplication,
  distrobox,
  fuzzel,
  coreutils,
  findutils,
  xdg-terminal-exec,
  lib,
}:
writeShellApplication {
  name = "fuzzel-distrobox";
  runtimeInputs = [
    distrobox
    fuzzel
    coreutils
    findutils
    xdg-terminal-exec
  ];
  text = "distrobox-list --no-color | tail -n+2 | cut -d'|' -f2 | xargs -r | fuzzel --dmenu --only-match | xargs -r -I{} xdg-terminal-exec -- distrobox-enter {}";
}

# {
#   environment.etc."distrobox/distrobox.conf".text = ''
#     container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
#   '';
# }
