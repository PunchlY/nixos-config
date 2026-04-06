{
  writeShellApplication,
  fuzzel,
  lib,
}:
writeShellApplication {
  name = "fuzzel-cmd-menu";
  runtimeInputs = [
    fuzzel
  ];
  text = let
    menu = [
      {
        key = "Game Mode";
        cmd = "steamosctl switch-to-game-mode";
      }
      {
        key = "Suspend";
        cmd = "systemctl suspend";
      }
      {
        key = "Reboot";
        cmd = "systemctl reboot";
      }
      {
        key = "Shutdown";
        cmd = "systemctl poweroff";
      }
    ];
  in ''
    cmds=( ${lib.escapeShellArgs (lib.catAttrs "cmd" menu)} )
    index=$(fuzzel --dmenu --index --only-match --minimal-lines <<< ${lib.escapeShellArg (lib.concatStringsSep "\n" (lib.catAttrs "key" menu))})
    [ -z "$index" ] && exit 0
    [ "$index" -lt 0 ] && exit 0
    eval "''${cmds[$index]}"
  '';
}
