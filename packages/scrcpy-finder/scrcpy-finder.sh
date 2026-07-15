#! @runtimeShell@
set -euo pipefail

if [ -t 1 ]; then
  is_tty=1
else
  is_tty=0
fi

menu() {
  if ((is_tty)); then
    @fzf@/bin/fzf --accept-nth 1 --with-nth {2..}
  else
    @fuzzel@/bin/fuzzel --dmenu --accept-nth 1 --only-match --no-run-if-empty --with-nth {2..}
  fi
}

find() {
  @net-tools@/bin/arp -a |
    @jc@/bin/jc --arp |
    @jq@/bin/jq -r '.[] | .address + "\t" + .name' | menu
}

tcpip="$(find)"

exec @scrcpy@/bin/scrcpy --tcpip="$tcpip" "$@"
