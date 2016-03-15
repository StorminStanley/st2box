#!/bin/sh

. /app/st2chatops.env

while true; do
  http_code=$(curl -L -s -o /dev/null -w "%{http_code}" ${ST2_API} --insecure)
  if [ "$http_code" -ge 500 ]; then
    echo ST2 API returns $http_code. Waiting...
  else
    echo ST2 API returns $http_code. Proceeding...
    break
  fi
  sleep 1
done
exec "$@"
