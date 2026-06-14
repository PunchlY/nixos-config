#! @bash@/bin/bash

if ! command -v waydroid >/dev/null 2>&1; then
  exit
fi

if waydroid status | @gnugrep@/bin/grep -q "^Session:.*RUNNING$"; then
  exit
fi

exec @cage@/bin/cage -s -- @startup@
