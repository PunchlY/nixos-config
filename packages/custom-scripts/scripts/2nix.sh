#! @runtimeShell@
set -euo pipefail

attr=

args=$(@getopt@/bin/getopt -o A: -l attr: -- "$@") || exit 2
eval "set -- $args"

while [[ $# -gt 0 ]]; do
  case "$1" in
  -A | --attr)
    attr=$2
    shift 2
    ;;
  --)
    shift
    break
    ;;
  *)
    break
    ;;
  esac
done

if ((!$#)); then
  set -- -
fi

@yq-go@/bin/yq ea -M -I 0 -o json '[.] | (select(length == 1) | .[0]) // .' -- "$@" |
  @nix@/bin/nix-instantiate --eval --readonly-mode --strict --arg-from-stdin json --expr '{json}: builtins.fromJSON json' --attr "$attr" |
  @nixfmt@/bin/nixfmt -
