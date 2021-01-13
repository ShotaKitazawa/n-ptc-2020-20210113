#!/bin/bash

# initialize db for scoring

ROOT_DIR=/home/ptc-user/app/common
DB_DIR="$ROOT_DIR/db"

MYSQL_DATABASE=app
MYSQL_USER=ptc-user
MYSQL_PASSWORD=resu-ctp
MYSQL_HOST=localhost
REVOCATION_LIST_TARGET=/home/ptc-user/app/revocated_token.list

# delete except initial data
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "DELETE FROM users WHERE id > 10379"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "DELETE FROM events WHERE id > 3696"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "TRUNCATE TABLE reservations"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < ${DB_DIR}/initial_reservations.sql
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "TRUNCATE TABLE timeslots"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < ${DB_DIR}/initial_timeslots.sql

if [[ -f "$DB_DIR/seed.list" ]]; then
    if [[ -f "${REVOCATION_LIST_TARGET}" ]]; then
      rm ${REVOCATION_LIST_TARGET}
    fi
    cp "${DB_DIR}/seed.list" "${REVOCATION_LIST_TARGET}"
fi
