#! @bash@/bin/bash
set -o nounset
set -o pipefail

OUTPUT="$(@wlr-randr@/bin/wlr-randr --json | @jq@/bin/jq -r .[0].name)"
CUSTOM_MODE="$(@xrandr@/bin/xrandr | @jc@/bin/jc --xrandr -p | @jq@/bin/jq -r '.screens.[0] | "\(.current_width)x\(.current_height)"')"

@wlr-randr@/bin/wlr-randr --output "$OUTPUT" --custom-mode "$CUSTOM_MODE"

{
  sleep 1
  sudo -nv && while [[ -z "$(sudo -n waydroid shell getprop sys.boot_completed)" ]]; do
    sleep 1
  done
  echo add | sudo -n tee /sys/devices/virtual/input/input*/event*/uevent
} &
FIX_PID=$!
trap 'kill "$FIX_PID" 2>/dev/null' EXIT

waydroid show-full-ui &

coproc LSWT { @expect@/bin/unbuffer -p @lswt@/bin/lswt -w; }
@gnugrep@/bin/grep -qm1 destroyed <&${LSWT[0]}
kill "$LSWT_PID"

waydroid session stop
sudo -n waydroid container stop

exit 0
