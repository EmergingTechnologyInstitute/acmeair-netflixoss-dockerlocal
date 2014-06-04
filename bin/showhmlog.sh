#!/bin/sh

. ./env.sh

asgc_addr=$($docker_cmd inspect --format '{{ .NetworkSettings.IPAddress }}' microscaler)

ssh -i id_rsa root@$asgc_addr << EOF
tail -f /var/log/supervisor/healthmanager-stderr---supervisor-*.log
EOF

