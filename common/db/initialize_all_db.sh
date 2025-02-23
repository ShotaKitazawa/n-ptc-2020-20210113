#!/bin/bash

# force DB initialization

ROOT_DIR=/home/ptc-user/app/common
DB_DIR="$ROOT_DIR/db"

MYSQL_DATABASE=app
MYSQL_USER=ptc-user
MYSQL_PASSWORD=resu-ctp
MYSQL_HOST=localhost
REVOCATION_LIST_TARGET=/home/ptc-user/app/revocated_token.list

echo '運営 > これはデータ初期化プログラムである。'
echo '運営 > 起動させる場合はyesを、'
echo '     > そうでない場合はnoを入力せよ。'
echo '運営 > 起動させた場合、あなたはDBやrevocation listの初期化を行なうことができる。'
echo '運営 > 非実行が選択された場合は実行されず終了する。'
echo -n '運営 > READY？ '
read  answer
case "${answer}" in
"yes")
  ;;
*)
  echo 'exit!'
  exit 1
  ;;
esac

mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "DROP DATABASE IF EXISTS $MYSQL_DATABASE; CREATE DATABASE $MYSQL_DATABASE;"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < "$DB_DIR/seed.sql"

if [[ -f "$DB_DIR/seed.list" ]]; then
    if [[ -f "${REVOCATION_LIST_TARGET}" ]]; then
      rm ${REVOCATION_LIST_TARGET}
    fi

    mv "${DB_DIR}/seed.list" "${REVOCATION_LIST_TARGET}"
fi
