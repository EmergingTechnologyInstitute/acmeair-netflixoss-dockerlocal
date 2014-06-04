#!/bin/sh

. ./env.sh

webapp_addr=$1

if [ -z "$webapp_addr" ]; then
  webapp_addr=$($docker_cmd ps | grep 'acmeair/webapp' | head -n 1 | cut -d' ' -f1 | xargs $docker_cmd inspect --format '{{.NetworkSettings.IPAddress}}')
fi

for i in `seq 0 1 10`
do
  curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null -c cookie.txt --data "login=uid0@email.com&password=password" $webapp_addr/rest/api/login
  curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null -b cookie.txt $webapp_addr/rest/api/customer/byid/uid0@email.com
  curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null -b cookie.txt --data "fromAirport=CDG&toAirport=JFK&fromDate=2014/03/31&returnDate=2014/03/31&oneWay=false" $webapp_addr/rest/api/flights/queryflights
  curl -sL -w "%{http_code} %{url_effective}\\n" -o /dev/null -b cookie.txt $webapp_addr/rest/api/login/logout?login=uid0@email.com
done

rm cookie.txt
