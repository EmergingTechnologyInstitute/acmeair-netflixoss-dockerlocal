#!/bin/sh

. ../bin/env.sh

cp microscaler.yml.template microscaler.yml
cp Dockerfile.template Dockerfile

sed -i 's/$admin_passwd/'`$pwgen_cmd -s 32 1`'/' microscaler.yml Dockerfile
sed -i 's/$auser_passwd/'`$pwgen_cmd -s 32 1`'/' microscaler.yml Dockerfile
sed -i 's/$imuser_passwd/'`$pwgen_cmd -s 32 1`'/' microscaler.yml Dockerfile
sed -i 's/$asguser_passwd/'`$pwgen_cmd -s 32 1`'/' microscaler.yml Dockerfile

$docker_cmd build -t acmeair/microscaler .

