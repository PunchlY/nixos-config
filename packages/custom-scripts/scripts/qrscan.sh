#! @runtimeShell@
set -euo pipefail

@wl-clipboard@/bin/wl-paste -t image | @zbar@/bin/zbarimg -q --raw -
