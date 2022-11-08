#!/bin/sh
set -x
cd `dirname $0`

ISUCON_DB_HOST=127.0.0.1
ISUCON_DB_PORT=${ISUCON_DB_PORT:-3306}
ISUCON_DB_USER=${ISUCON_DB_USER:-isucon}
ISUCON_DB_PASSWORD=${ISUCON_DB_PASSWORD:-isucon}
ISUCON_DB_NAME=${ISUCON_DB_NAME:-isucon}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}

sudo mysql -uroot \
		-p"$MYSQL_ROOT_PASSWORD" \
		--host "$ISUCON_DB_HOST" \
		--port "$ISUCON_DB_PORT"  < 0_setup.sql


mysql -u"$ISUCON_DB_USER" \
		-p"$ISUCON_DB_PASSWORD" \
		--host "$ISUCON_DB_HOST" \
		--port "$ISUCON_DB_PORT" \
		"$ISUCON_DB_NAME" < 1_schema.sql

mysql -u"$ISUCON_DB_USER" \
		-p"$ISUCON_DB_PASSWORD" \
		--host "$ISUCON_DB_HOST" \
		--port "$ISUCON_DB_PORT" \
		"$ISUCON_DB_NAME" < 2_init.sql

echo "INSERT INTO user_presents_deleted (id, user_id, sent_at, item_type, item_id, amount, present_message, created_at, updated_at, deleted_at) SELECT * FROM user_presents WHERE deleted_at IS NOT NULL;
      DELETE FROM user_presents WHERE deleted_at IS NOT NULl;" | mysql -u"$ISUCON_DB_USER" \
		-p"$ISUCON_DB_PASSWORD" \
		--host "$ISUCON_DB_HOST" \
		--port "$ISUCON_DB_PORT" \
		"$ISUCON_DB_NAME"