#! @bash@/bin/bash
set -o errexit
set -o nounset
set -o pipefail

mapfile -t paths < <(
  if (($#)); then
    for arg in "$@"; do
      case "$arg" in
      /* | ./* | ../* | . | ..)
        [[ -e $arg ]] && echo "$arg"
        ;;
      *)
        which -- "$arg"
        ;;
      esac
    done
  else
    @coreutils@/bin/tr ':' '\n' <<<"$PATH"
  fi
)
((!${#paths[@]})) && exit

mapfile -t paths < <(
  @coreutils@/bin/realpath -qe "${paths[@]}" |
    @gawk@/bin/awk '!seen[$0]++' |
    @gnugrep@/bin/grep '^/nix/store/'
)
((!${#paths[@]})) && exit

if [ -t 1 ]; then
  is_tty=1
else
  is_tty=0
fi
export is_tty

show() {
  nix derivation show "$1" |
    if ((is_tty)); then
      @jq@/bin/jq -r '.derivations.[] | "\u001b]8;;file:///nix/store/" + (.outputs.bin.path // .outputs.out.path | @uri) + "\u0007" + .name + "\u001b]8;;\u0007"'
    else
      @jq@/bin/jq -r .derivations.[].name
    fi
}
export -f show

SHELL=@bash@/bin/bash @parallel@/bin/parallel --env is_tty 'show {} 2>/dev/null || true' ::: "${paths[@]}"
