#!/bin/sh

POSTGRES_USER=${POSTGRES_USER:-mistral}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-StackStorm}
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_DB=${POSTGRES_DB:-mistral}

RABBITMQ_USER=${RABBITMQ_USER:-guest}
RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD:-guest}
RABBITMQ_HOST=${RABBITMQ_HOST:-rabbitmq}

# Generate config file
generate_config_file() {
  # Configuration has been already altered, so skip generation!
  (md5sum --quiet -c /mistral.conf.orig.md5) || return 0

  cat /mistral.conf.template \
    | sed -r "s|^(connection.=.).*|\1postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST/$POSTGRES_DB|" \
    | sed -r "s|^(transport_url.=.).*|\1rabbit://$RABBITMQ_USER:$RABBITMQ_PASSWORD@$RABBITMQ_HOST|" \
    > /etc/mistral/mistral.conf
}

generate_config_file

populate_db() {
  until nc -z $POSTGRES_HOST 5432; do
    echo "PostgreSQL doesn't respond. Waiting..."
    sleep 1
  done

  /opt/stackstorm/mistral/bin/mistral-db-manage --config-file /etc/mistral/mistral.conf upgrade head
  /opt/stackstorm/mistral/bin/mistral-db-manage --config-file /etc/mistral/mistral.conf populate
}

case "$MISTRAL_SERVICE" in
"api")
  populate_db
  ARGS="${@:---log-file=- -b 0.0.0.0:8989 -w 2 --graceful-timeout 10 mistral.api.wsgi}"
  CMD="/opt/stackstorm/mistral/bin/gunicorn $ARGS"
  ;;
"engine")
  populate_db
  ARGS="${@:---config-file /etc/mistral/mistral.conf}"
  CMD="/opt/stackstorm/mistral/bin/mistral-server --server engine $ARGS"
  ;;
"executor")
  ARGS="${@:---config-file /etc/mistral/mistral.conf}"
  CMD="/opt/stackstorm/mistral/bin/mistral-server --server executor $ARGS"
  ;;
*)
  CMD="$@"
esac

exec $CMD
