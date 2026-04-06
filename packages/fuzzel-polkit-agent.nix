{
  writeTextFile,
  runtimeShell,
  jq,
  fuzzel,
  cmd-polkit,
  lib,
  libnotify,
}:
writeTextFile {
  name = "fuzzel-polkit-agent";
  destination = "/libexec/fuzzel-polkit-agent";
  executable = true;
  text = ''
    #!${runtimeShell}
    export PATH="${
      lib.escapeShellArg (
        lib.makeBinPath [
          jq
          fuzzel
          cmd-polkit
          libnotify
        ]
      )
    }:$PATH"
    exec cmd-polkit-agent -sv -c ${lib.escapeShellArg "${runtimeShell} -c ${lib.escapeShellArg ''
      set -o errexit
      set -o nounset
      set -o pipefail
      INFO_PID=
      while read -r msg; do
        if [ -n "$INFO_PID" ]; then
          kill $INFO_PID
          INFO_PID=
        fi
        case "$(<<<"$msg" jq -rc .action)" in
          'request password')
            </dev/null \
            fuzzel --dmenu \
              --namespace=fuzzel-polkit-agent \
              --password= \
              --prompt-only="$(<<<"$msg" jq -rc .prompt)" \
              --mesg="$(<<<"$msg" jq -rc .message)" |
            jq -Rc '{ action: "authenticate", password: . }' \
            || echo '{"action":"cancel"}'
            ;;
          'show info')
            {
              trap 'kill $FUZZEL_PID; FUZZEL_PID=' SIGTERM
              </dev/null \
              fuzzel --dmenu \
                --namespace=fuzzel-polkit-agent \
                --hide-prompt \
                --lines=0 \
                --mesg="$(<<<"$msg" jq -rc .text)" \
                --only-match &
              FUZZEL_PID=$!
              wait $FUZZEL_PID || [ -n "$FUZZEL_PID" ] && echo '{"action":"cancel"}'
            } &
            INFO_PID=$!
            ;;
          'show error')
            notify-send "$(<<<"$msg" jq -rc .text)"
            ;;
        esac
      done
    ''}"}
  '';
}
