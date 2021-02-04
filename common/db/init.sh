#!/bin/bash

# initialize db for scoring

ROOT_DIR=/home/ptc-user/app/common
DB_DIR="$ROOT_DIR/db"

MYSQL_DATABASE=app
MYSQL_USER=ptc-user
MYSQL_PASSWORD=resu-ctp
MYSQL_HOST=localhost
REVOCATION_LIST_TARGET=/home/ptc-user/app/revocated_token.list

# delete except initial data (image in local disk)
ls /home/ptc-user/app/public/api/events | awk '{if ($0 > 3696) print $0}' | xargs -I{} rm -rf /home/ptc-user/app/public/api/events/{}

# delete except initial data
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "DELETE FROM users WHERE id > 10379"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "DELETE FROM events WHERE id > 3696"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "TRUNCATE TABLE reservations"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE < ${DB_DIR}/initial_reservations.sql
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "TRUNCATE TABLE timeslots"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE < ${DB_DIR}/initial_timeslots.sql


# index
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE reservations ADD INDEX event_id(event_id)"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE reservations ADD INDEX event_id_user_id(event_id,user_id)"
MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE timeslots ADD INDEX event_id(event_id)"
# 以下は実行済み
#MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE users CHANGE username username VARCHAR(32)"
#MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE users ADD INDEX username(username)"
#MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE events ADD INDEX start_at(start_at)"
#MYSQL_PWD=$MYSQL_PASSWORD mysql -h $MYSQL_HOST -u$MYSQL_USER $MYSQL_DATABASE -e "ALTER TABLE events ADD INDEX User_id(user_id)"

#if [[ -f "$DB_DIR/seed.list" ]]; then
#    if [[ -f "${REVOCATION_LIST_TARGET}" ]]; then
#      rm ${REVOCATION_LIST_TARGET}
#    fi
#    cp "${DB_DIR}/seed.list" "${REVOCATION_LIST_TARGET}"
#fi
