#! @runtimeShell@
set -euo pipefail

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

if [ -t 1 ]; then
  is_tty=1
else
  is_tty=0
fi

show() {
  @nix@/bin/nix derivation show "$2" |
    if ((is_tty)); then
      @jq@/bin/jq -r '.derivations.[] | "\u001b]8;;file:///nix/store/" + (.outputs.bin.path // .outputs.out.path | @uri) + "\u0007" + .name + "\u001b]8;;\u0007"'
    else
      @jq@/bin/jq -r .derivations.[].name
    fi
}

@coreutils@/bin/realpath -qe "${paths[@]}" |
  @gawk@/bin/awk '!seen[$0]++' |
  @gnugrep@/bin/grep '^/nix/store/' |
  mapfile -c 1 -C show -t
