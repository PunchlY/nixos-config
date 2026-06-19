#! @runtimeShell@

@iproute2@/bin/ip -o addr show | @gawk@/bin/awk '{print $2, $4}' | @util-linux@/bin/column -t
