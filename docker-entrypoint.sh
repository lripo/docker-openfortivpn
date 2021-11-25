#!/bin/bash

# Start proxy
[ "${GLIDER_VERBOSE}" == "true" ] && verbose="-verbose"
pkill -9 -f glider || /bin/true
GLIDER_CMD="/usr/bin/glider -listen :8080 ${verbose}"
echo
echo ">>>>> Running: $GLIDER_CMD"
echo
$GLIDER_CMD &

# Execute CMD
echo
echo ">>>>> Running: $@"
echo
$@
