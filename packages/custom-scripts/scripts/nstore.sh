#! @runtimeShell@
set -euo pipefail

[ -z "$1" ] && exit

basename="${2:-$(@coreutils@/bin/basename "$1")}"

store="$(nix store add "$1" --name "$basename")"

hash="$(nix-hash --to-sri --type sha256 "$(@nix@/bin/nix-store --query --hash "$store")")"

name="$(@coreutils@/bin/basename "$store" | @gnused@/bin/sed 's/^[a-z0-9]\{32\}-//')"

@nix@/bin/nix-store --add-root "$XDG_DATA_HOME/nstore/$name" --indirect --realise $store

echo "requireFile {
  name = \"$name\";
  url = "...";
  hash = \"$hash\";
}"
