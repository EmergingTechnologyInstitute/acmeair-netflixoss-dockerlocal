#!/bin/sh

. ./env.sh

asgc_addr=$($docker_cmd inspect --format '{{ .NetworkSettings.IPAddress }}' microscaler)

ssh -i id_rsa root@$asgc_addr << EOF
cd /usr/local/microscaler-cli/bin &&\
./ms login --target http://localhost:56785/asgcc/ --user user01 --key key &&\
\
./ms add-lconf \
--lconf-name acmeair_auth_service \
--lconf-image-id acmeair/auth-service${as_suffix} \
--lconf-instances-type m1.small \
--lconf-key key1 &&\
\
./ms add-lconf \
--lconf-name acmeair_webapp \
--lconf-image-id acmeair/webapp${as_suffix} \
--lconf-instances-type m1.small \
--lconf-key key1 &&\
\
./ms add-asg \
--asg-name acmeair_auth_service \
--asg-availability-zones docker-local-1a,docker-local-1b,docker-local-1c \
--asg-launch-configuration acmeair_auth_service \
--asg-min-size 3 \
--asg-desired-capacity 3 \
--asg-max-size 12 \
--asg-scale-out-cooldown 300 \
--asg-scale-in-cooldown 60 \
--asg-domain auth-service.local.flyacmeair.net &&\
\
./ms add-asg \
--asg-name acmeair_webapp \
--asg-availability-zones docker-local-1a,docker-local-1b,docker-local-1c \
--asg-launch-configuration acmeair_webapp \
--asg-min-size 3 \
--asg-desired-capacity 3 \
--asg-max-size 12 \
--asg-scale-out-cooldown 300 \
--asg-scale-in-cooldown 60 \
--asg-domain webapp.local.flyacmeair.net
EOF

