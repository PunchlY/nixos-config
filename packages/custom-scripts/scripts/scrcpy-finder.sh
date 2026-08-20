#! @runtimeShell@
set -euo pipefail

if [ -t 1 ]; then
  is_tty=1
else
  is_tty=0
fi

menu() {
  if ((is_tty)); then
    @fzy@/bin/fzy
  else
    @fuzzel@/bin/fuzzel --dmenu --only-match --no-run-if-empty
  fi
}

find() {
  @net-tools@/bin/arp -a |
    menu |
    @jc@/bin/jc --arp |
    @jq@/bin/jq -r '.[0].address'
}

tcpip="$(find)"

exec @scrcpy@/bin/scrcpy --tcpip="$tcpip" "$@"
