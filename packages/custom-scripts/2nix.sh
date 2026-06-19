#! @runtimeShell@
set -o errexit
set -o nounset
set -o pipefail

if ((!$#)); then
  set -- -
fi
export value="$(@yq-go@/bin/yq ea -M -I 0 -o json '[.]' -- "$@")"
nix eval --impure --expr 'let value = builtins.fromJSON (builtins.getEnv "value"); in if builtins.length value == 1 then builtins.elemAt value 0 else value' | @nixfmt@/bin/nixfmt -
