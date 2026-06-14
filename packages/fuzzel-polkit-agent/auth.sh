#! @bash@/bin/bash
set -o errexit
set -o nounset
set -o pipefail

INFO_PID=
while read -r msg; do
  if [ -n "$INFO_PID" ]; then
    kill "$INFO_PID"
    INFO_PID=
  fi
  case "$(@jq@/bin/jq -rc .action <<<"$msg")" in
  'request password')
    @fuzzel@/bin/fuzzel --dmenu \
      --namespace=fuzzel-polkit-agent \
      --password= \
      --prompt-only="$(@jq@/bin/jq -rc .prompt <<<"$msg")" \
      --mesg="$(@jq@/bin/jq -rc .message <<<"$msg")" </dev/null |
      @jq@/bin/jq -Rc '{ action: "authenticate", password: . }' ||
      echo '{"action":"cancel"}'
    ;;
  'show info')
    {
      trap 'kill "$FUZZEL_PID"' SIGTERM
      @fuzzel@/bin/fuzzel --dmenu \
        --namespace=fuzzel-polkit-agent \
        --hide-prompt \
        --lines=0 \
        --mesg="$(@jq@/bin/jq -rc .text <<<"$msg")" \
        --only-match </dev/null &
      FUZZEL_PID=$!
      wait "$FUZZEL_PID" || echo '{"action":"cancel"}'
    } &
    INFO_PID=$!
    ;;
  'show error')
    @libnotify@/bin/notify-send "$(@jq@/bin/jq -rc .text <<<"$msg")"
    ;;
  esac
done
