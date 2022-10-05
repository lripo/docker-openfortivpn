#!/bin/bash

# Start proxy
[ "${GLIDER_VERBOSE}" == "true" ] && verbose="-verbose"
pkill -9 -f glider || /bin/true
GLIDER_CMD="/usr/bin/glider -listen :8080 ${verbose}"
echo
echo ">>>>> Running: $GLIDER_CMD"
echo
$GLIDER_CMD &

# Start dnsmasq
# Shit, stupid dnsmasq tries to close all possible fds before starting
# Better yet, use docker run with --ulimit nofile=8192:8192
# Nope, start from /etc/ppp/ip-up.local
# dnsmasq

# Execute CMD
echo
echo ">>>>> Running: $@"
echo
$@
