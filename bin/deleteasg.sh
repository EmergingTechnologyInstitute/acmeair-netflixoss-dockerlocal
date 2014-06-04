#!/bin/sh

. ./env.sh

asgc_addr=$($docker_cmd inspect --format '{{ .NetworkSettings.IPAddress }}' microscaler)

./stopasg.sh

ssh -i id_rsa root@$asgc_addr << EOF
cd /usr/local/microscaler-cli/bin &&\
./ms login --target http://localhost:56785/asgcc/ --user user01 --key key &&\

./ms delete-asg --asg-name acmeair_auth_service
./ms delete-lconf --lconf-name acmeair_auth_service
./ms delete-asg --asg-name acmeair_webapp
./ms delete-lconf --lconf-name acmeair_webapp
EOF

