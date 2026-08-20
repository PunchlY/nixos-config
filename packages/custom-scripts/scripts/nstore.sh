#! @runtimeShell@
set -euo pipefail

[ -z "$1" ] && exit

store="$(@nix@/bin/nix-store --add-fixed sha256 "$1")"

hash="$(@nix@/bin/nix hash file --type sha256 --sri "$1")"

name="$(@coreutils@/bin/basename "$1")"

@nix@/bin/nix-store --add-root "$XDG_DATA_HOME/nstore/$name" --indirect --realise $store

echo "requireFile {
  name = \"$name\";
  url = \"...\";
  hash = \"$hash\";
}"
