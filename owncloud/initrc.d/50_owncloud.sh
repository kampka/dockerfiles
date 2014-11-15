#!/bin/sh

set -e

OWNCLOUD_INSTALL_DIR=/usr/share/webapps/owncloud
OWNCLOUD_CONFIG_DIR=${OWNCLOUD_CONFIG_DIR:-/etc/webapps/owncloud/config}

[ -e "$OWNCLOUD_CONFIG_DIR/owncloud.conf" ] && . "$OWNCLOUD_CONFIG_DIR/owncloud.conf"

OWNCLOUD_DATA_DIR=${OWNCLOUD_DATA_DIR:-/data}

[ -e "$OWNCLOUD_DATA_DIR/owncloud.conf" ] && . "$OWNCLOUD_DATA_DIR/owncloud.conf"

OWNCLOUD_DB_NAME=${OWNCLOUD_DB_NAME:-owncloud}
OWNCLOUD_DB_USER=${OWNCLOUD_DB_USER:-owncloud}
OWNCLOUD_DB_PASS=${OWNCLOUD_DB_PASS:-owncloud}
OWNCLOUD_DB_HOST=${OWNCLOUD_DB_HOST:-postgres}
OWNCLOUD_DB_PREFIX=${OWNCLOUD_DB_PREFIX:-}
OWNCLOUD_DB_ADMIN_USER=${OWNCLOUD_DB_ADMIN_USER:-root}
OWNCLOUD_DB_ADMIN_PASS=${OWNCLOUD_DB_ADMIN_PASS:-owncloud}

OWNCLOUD_FORCE_SSL=${OWNCLOUD_FORCE_SSL:-true}
OWNCLOUD_TRUSTED_DOMAIN=${OWNCLOUD_TRUSTED_DOMAIN:-example.com}
OWNCLOUD_DEFAULT_LANG=${OWNCLOUD_DEFAULT_LANG:-en}
OWNCLOUD_THIRD_PARTY_ROOT=${OWNCLOUD_THIRD_PARTY_ROOT:-}
OWNCLOUD_THIRD_PARTY_URL=${OWNCLOUD_THIRD_PARTY_URL:-}
OWNCLOUD_DEFAULT_APP=${OWNCLOUD_DEFAULT_APP:-file}
OWNCLOUD_APPSTORE_ENABLED=${OWNCLOUD_APPSTORE_ENABLED:-true}
OWNCLOUD_APPS_DIR=${OWNCLOUD_APPS_DIR:-${OWNCLOUD_DATA_DIR}/apps}
OWNCLOUD_STORAGE_DIR=${OWNCLOUD_STORAGE_DIR:-${OWNCLOUD_DATA_DIR}/storage}


OWNCLOUD_MAIL_DOMAIN=${OWNCLOUD_MAIL_DOMAIN:-www.gmail.com}
OWNCLOUD_SMTP_HOST=${OWNCLOUD_SMTP_HOST:-smtp.gmail.com}
OWNCLOUD_SMTP_PORT=${OWNCLOUD_SMTP_PORT:-587}
OWNCLOUD_SMTP_TIMEOUT=${OWNCLOUD_SMTP_TIMEOUT:-30}
OWNCLOUD_SMTP_SECURE=${OWNCLOUD_SMTP_SECURE:-tls}
OWNCLOUD_SMTP_AUTH=${OWNCLOUD_SMTP_AUTH:-true}
OWNCLOUD_SMTP_AUTH_TYPE=${OWNCLOUD_SMTP_AUTH_TYPE:-LOGIN}
OWNCLOUD_SMTP_USER=${OWNCLOUD_SMTP_USER:-}
OWNCLOUD_SMTP_PASS=${OWNCLOUD_SMTP_PASS:-}
if [ -n "${OWNCLOUD_SMTP_USER}" ]; then
  OWNCLOUD_SMTP_MODE=${OWNCLOUD_SMTP_MODE:-smtp}
fi
OWNCLOUD_SMTP_MODE=${OWNCLOUD_SMTP_MODE:-sendmail}

OWNCLOUD_TRASHBIN_RETENTION=${OWNCLOUD_TRASHBIN_RETENTION:-30}
OWNCLOUD_TRASHBIN_EXPIRE=${OWNCLOUD_TRASHBIN_EXPIRE:-true}
OWNCLOUD_ALLOW_DISPLAY_NAME_CHANGE=${OWNCLOUD_ALLOW_DISPLAY_NAME_CHANGE:-true}
OWNCLOUD_APPCODE_CHECKER=${OWNCLOUD_APPCODE_CHECKER:-true}
OWNCLOUD_UPDATE_CHECKER=${OWNCLOUD_UPDATE_CHECKER:-true}
OWNCLOUD_HAS_INTERNET=${OWNCLOUD_HAS_INTERNET:-true}
OWNCLOUD_CHECK_WEBDAV=${OWNCLOUD_CHECK_WEBDAV:-true}
OWNCLOUD_CHECK_HTACCESS=${OWNCLOUD_CHECK_HTACCESS:-true}
OWNCLOUD_LOG_TYPE=${OWNCLOUD_LOG_TYPE:-owncloud}
OWNCLOUD_LOG_FILE=${OWNCLOUD_LOG_FILE:-${OWNCLOUD_DATA_DIR}/log/owncloud/owncloud.log}
OWNCLOUD_LOG_LEVEL=${OWNCLOUD_LOG_LEVEL:-1}
OWNCLOUD_LOG_TIMEZONE=${OWNCLOUD_LOG_TIMEZONE:-UTC}
OWNCLOUD_LOG_QUERY=${OWNCLOUD_LOG_QUERY:-false}
OWNCLOUD_CRON_LOG=${OWNCLOUD_CRON_LOG:-true}
OWNCLOUD_LOG_ROTATE_SIZE=${OWNCLOUD_LOG_ROTATE_SIZE:-100Mib}
OWNCLOUD_LOGIN_COOKIE_LIFETIME=${OWNCLOUD_LOGIN_COOKIE_LIFETIME:-1296000}
OWNCLOUD_SESSION_LIFETIME=${OWNCLOUD_SESSION_LIFETIME:-86400}
OWNCLOUD_SESSION_KEEPALIVE=${OWNCLOUD_SESSION_KEEPALIVE:-true}

PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-1024M}
PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-1024M}
PHP_MAX_UPLOAD_FILESIZE=${PHP_MAX_UPLOAD_FILESIZE:-1024M}
PHP_MAX_UPLOAD_FILES=${PHP_MAX_UPLOAD_FILES:-24}
PHP_XCACHE_SIZE=${PHP_XCACHE_SIZE:-64}
PHP_XCACHE_VARSIZE=${PHP_XCACHE_VARSIZE:-64}

mkdir -p ${OWNCLOUD_DATA_DIR}

mkdir -p ${OWNCLOUD_DATA_DIR}/storage
touch ${OWNCLOUD_DATA_DIR}/storage/.ocdata
chown -R www-data:www-data ${OWNCLOUD_DATA_DIR}/storage

mkdir -p ${OWNCLOUD_DATA_DIR}/log/{owncloud,php,cron}
chown -R www-data:www-data ${OWNCLOUD_DATA_DIR}/log/{owncloud,php}

mkdir -p ${OWNCLOUD_DATA_DIR}/config
chown -R www-data:www-data ${OWNCLOUD_DATA_DIR}/config

mkdir -p ${OWNCLOUD_DATA_DIR}/apps
cp -r ${OWNCLOUD_INSTALL_DIR}/apps/* ${OWNCLOUD_DATA_DIR}/apps
chown -R www-data:www-data ${OWNCLOUD_DATA_DIR}/apps


# Configure php-fpm
sed -i 's,{{OWNCLOUD_DATA_DIR}},'"${OWNCLOUD_DATA_DIR}"',g' "/etc/php/php-fpm.conf"

# Configure php.ini
sed -i 's,{{OWNCLOUD_DATA_DIR}},'"${OWNCLOUD_DATA_DIR}"',g' "/etc/php/php.ini"
sed -i 's/{{PHP_MEMORY_LIMIT}}/'"${PHP_MEMORY_LIMIT}"'/g' "/etc/php/php.ini"
sed -i 's/{{PHP_POST_MAX_SIZE}}/'"${PHP_POST_MAX_SIZE}"'/g' "/etc/php/php.ini"
sed -i 's/{{PHP_MAX_UPLOAD_FILESIZE}}/'"${PHP_MAX_UPLOAD_FILESIZE}"'/g' "/etc/php/php.ini"
sed -i 's/{{PHP_MAX_UPLOAD_FILES}}/'"${PHP_MAX_UPLOAD_FILES}"'/g' "/etc/php/php.ini"
sed -i 's/{{PHP_XCACHE_SIZE}}/'"${PHP_XCACHE_SIZE}"'/g' "/etc/php/php.ini"
sed -i 's/{{PHP_XCACHE_VARSIZE}}/'"${PHP_XCACHE_VARSIZE}"'/g' "/etc/php/php.ini"



echo "Verifying database settings"
timeout=60

export PGPASSWORD="$OWNCLOUD_DB_PASS"

while ! psql -h $OWNCLOUD_DB_HOST -U $OWNCLOUD_DB_USER -d $OWNCLOUD_DB_NAME -c "" 2>/dev/null ; do
  timeout=$((timeout-1))
  if [ $timeout -eq 0 ]; then
    echo "Could not connect to database. Aborting." 1>&2
    exit 1
  fi
  sleep 1
done

QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';"
COUNT=$(psql -h $OWNCLOUD_DB_HOST -U $OWNCLOUD_DB_USER -d $OWNCLOUD_DB_NAME -Atw -c "${QUERY}" 2>/dev/null)

if [ -z "${COUNT}" -o ${COUNT} -eq 0 ]; then
  echo "Setting up Owncloud database."
  cp ${OWNCLOUD_CONFIG_DIR}/autoconfig.php.tmpl ${OWNCLOUD_CONFIG_DIR}/autoconfig.php
  chown www-data:www-data ${OWNCLOUD_CONFIG_DIR}/autoconfig.php
  sed -i 's/{{OWNCLOUD_DB_NAME}}/'"${OWNCLOUD_DB_NAME}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_USER}}/'"${OWNCLOUD_DB_USER}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_PASS}}/'"${OWNCLOUD_DB_PASS}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_HOST}}/'"${OWNCLOUD_DB_HOST}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_PREFIX}}/'"${OWNCLOUD_DB_PREFIX}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_ADMIN_USER}}/'"${OWNCLOUD_DB_ADMIN_USER}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"
  sed -i 's/{{OWNCLOUD_DB_ADMIN_PASS}}/'"${OWNCLOUD_DB_ADMIN_PASS}"'/g' "${OWNCLOUD_CONFIG_DIR}/autoconfig.php"

  cd ${OWNCLOUD_INSTALL_DIR}
  php -f index.php
  
  PWSALT=$(php -r "include('${OWNCLOUD_CONFIG_DIR}/config.php'); echo \$CONFIG['passwordsalt'];")
  INSTANCE=$(php -r "include('${OWNCLOUD_CONFIG_DIR}/config.php'); echo \$CONFIG['instanceid'];")

  mkdir -p /data/config/
  cat > /data/config/00_instance.php <<EOF
<?php

# Generated by setup.
# DO NOT EDIT

\$CONFIG = array_merge(\$CONFIG, array(
  'passwordsalt' => '$PWSALT',
  'instanceid' => '$INSTANCE',
));
EOF

  # Set background job mode to cron
  QUERY="INSERT INTO appconfig (appid, configkey, configvalue) VALUES ('core', 'backgroundjobs_mode', 'cron');"
  psql -h $OWNCLOUD_DB_HOST -U $OWNCLOUD_DB_USER -d $OWNCLOUD_DB_NAME -Atw -c "SELECT * from appconfig;"

fi

sed -i 's/{{OWNCLOUD_DB_NAME}}/'"${OWNCLOUD_DB_NAME}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_USER}}/'"${OWNCLOUD_DB_USER}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_PASS}}/'"${OWNCLOUD_DB_PASS}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_HOST}}/'"${OWNCLOUD_DB_HOST}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_PREFIX}}/'"${OWNCLOUD_DB_PREFIX}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_ADMIN_USER}}/'"${OWNCLOUD_DB_ADMIN_USER}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DB_ADMIN_PASS}}/'"${OWNCLOUD_DB_ADMIN_PASS}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_DATA_DIR}},'"${OWNCLOUD_DATA_DIR}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_INSTALL_DIR}},'"${OWNCLOUD_INSTALL_DIR}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"

sed -i 's,{{OWNCLOUD_APPS_DIR}},'"${OWNCLOUD_APPS_DIR}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_STORAGE_DIR}},'"${OWNCLOUD_STORAGE_DIR}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"

sed -i 's/{{OWNCLOUD_FORCE_SSL}}/'"${OWNCLOUD_FORCE_SSL}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DEFAULT_LANG}}/'"${OWNCLOUD_DEFAULT_LANG}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_TRUSTED_DOMAIN}},'"${OWNCLOUD_TRUSTED_DOMAIN}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_THIRD_PARTY_ROOT}}/'"${OWNCLOUD_THIRD_PARTY_ROOT}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_THIRD_PARTY_URL}},'"${OWNCLOUD_THIRD_PARTY_URL}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_DEFAULT_APP}}/'"${OWNCLOUD_DEFAULT_APP}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_APPSTORE_ENABLED}}/'"${OWNCLOUD_APPSTORE_ENABLED}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_MAIL_DOMAIN}}/'"${OWNCLOUD_MAIL_DOMAIN}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_MAIL_FROM}}/'"${OWNCLOUD_MAIL_FROM}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_MODE}}/'"${OWNCLOUD_SMTP_MODE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_HOST}}/'"${OWNCLOUD_SMTP_HOST}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_PORT}}/'"${OWNCLOUD_SMTP_PORT}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_TIMEOUT}}/'"${OWNCLOUD_SMTP_TIMEOUT}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_SECURE}}/'"${OWNCLOUD_SMTP_SECURE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_AUTH}}/'"${OWNCLOUD_SMTP_AUTH}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_AUTH_TYPE}}/'"${OWNCLOUD_SMTP_AUTH_TYPE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_USER}}/'"${OWNCLOUD_SMTP_USER}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SMTP_PASS}}/'"${OWNCLOUD_SMTP_PASS}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_TRASHBIN_RETENTION}}/'"${OWNCLOUD_TRASHBIN_RETENTION}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_TRASHBIN_EXPIRE}}/'"${OWNCLOUD_TRASHBIN_EXPIRE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_ALLOW_DISPLAY_NAME_CHANGE}}/'"${OWNCLOUD_ALLOW_DISPLAY_NAME_CHANGE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_APPCODE_CHECKER}}/'"${OWNCLOUD_APPCODE_CHECKER}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_UPDATE_CHECKER}}/'"${OWNCLOUD_UPDATE_CHECKER}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_HAS_INTERNET}}/'"${OWNCLOUD_HAS_INTERNET}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_CHECK_WEBDAV}}/'"${OWNCLOUD_CHECK_WEBDAV}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_CHECK_HTACCESS}}/'"${OWNCLOUD_CHECK_HTACCESS}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOG_TYPE}}/'"${OWNCLOUD_LOG_TYPE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's,{{OWNCLOUD_LOG_FILE}},'"${OWNCLOUD_LOG_FILE}"',g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOG_LEVEL}}/'"${OWNCLOUD_LOG_LEVEL}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOG_TIMEZONE}}/'"${OWNCLOUD_LOG_TIMEZONE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOG_QUERY}}/'"${OWNCLOUD_LOG_QUERY}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_CRON_LOG}}/'"${OWNCLOUD_CRON_LOG}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOG_ROTATE_SIZE}}/'"${OWNCLOUD_LOG_ROTATE_SIZE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_LOGIN_COOKIE_LIFETIME}}/'"${OWNCLOUD_LOGIN_COOKIE_LIFETIME}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SESSION_LIFETIME}}/'"${OWNCLOUD_SESSION_LIFETIME}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"
sed -i 's/{{OWNCLOUD_SESSION_KEEPALIVE}}/'"${OWNCLOUD_SESSION_KEEPALIVE}"'/g' "${OWNCLOUD_CONFIG_DIR}/config.base.php"


VERSION=$(php -r "include('${OWNCLOUD_INSTALL_DIR}/version.php'); echo implode(\$OC_Version, '.');")
if [ -e ${OWNCLOUD_DATA_DIR}/OWNCLOUD_VERSION ]; then
  INSTALLED_VERSION=$(cat ${OWNCLOUD_DATA_DIR}/OWNCLOUD_VERSION)
  if [ "$VERSION" != "$INSTALLED_VERSION" ]; then
    echo "Migrating owncloud from version $INSTALLED_VERSION to version $VERSION"
    php ${OWNCLOUD_INSTALL_DIR}/occ upgrade
  fi
fi
cat > /data/config/00_version.php <<EOF
<?php

# Generated by setup.
# DO NOT EDIT

\$CONFIG = array_merge(\$CONFIG, array(
  'version' => '$VERSION',
));
EOF
echo $VERSION > ${OWNCLOUD_DATA_DIR}/OWNCLOUD_VERSION

cp ${OWNCLOUD_CONFIG_DIR}/config.php.tmpl ${OWNCLOUD_CONFIG_DIR}/config.php

for f in ${OWNCLOUD_DATA_DIR}/config/*.php; do
  echo "require('$f');" >> ${OWNCLOUD_CONFIG_DIR}/config.php
done

chown -R www-data:www-data ${OWNCLOUD_CONFIG_DIR}

echo "Scanning files"

echo "Scanning files. This may take a while.."
/usr/bin/php -f ${OWNCLOUD_INSTALL_DIR}/occ files:scan --all 1>/dev/null

echo "Init complete"
