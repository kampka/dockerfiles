#!/bin/sh

set -e

GITLAB_INSTALL_DIR="/usr/share/webapps/gitlab"
GITLAB_SHELL_INSTALL_DIR="/usr/share/webapps/gitlab-shell"
GITLAB_CONFIG_DIR=${GITLAB_CONFIG_DIR:-/etc/webapps/gitlab}
GITSHELL_CONFIG_DIR=${GITSHELL_CONFIG_DIR:-/etc/webapps/gitlab-shell}

[ -e "$GITLAB_CONFIG_DIR/gitlab.conf" ] && . "$GITLAB_CONFIG_DIR/gitlab.conf"
[ -e "$GITLAB_DATA_DIR/gitlab.conf" ] && . "$GITLAB_DATA_DIR/gitlab.conf"

POSTGRES_DATABASE_NAME=${POSTGRES_DATABASE_NAME:-gitlab}
POSTGRES_DATABASE_ENCODING=${POSTGRES_DATABASE_ENCODING:-unicode}
POSTGRES_DATABASE_POOL=${POSTGRES_DATABASE_POOL:-10}
POSTGRES_DATABASE_USER=${POSTGRES_DATABASE_USER:-gitlab}
POSTGRES_DATABASE_PASSWORD=${POSTGRES_DATABASE_PASSWORD:-gitlab}
POSTGRES_DATABASE_HOST=${POSTGRES_DATABASE_HOST:-postgres}
POSTGRES_DATABASE_PORT=${POSTGRES_DATABASE_PORT:-5432}

GL_REDIS_HOST=${GL_REDIS_HOST:-redis}
GL_REDIS_PORT=${GL_REDIS_PORT:-6379}

GITLAB_DATA_DIR=${GITLAB_DATA_DIR:-/data}
GITLAB_HOST=${GITLAB_HOST:-localhost}
GITLAB_PORT=${GITLAB_PORT:-80}
GITLAB_HTTPS=${GITLAB_HTTPS:-false}
GITLAB_EMAIL=${GITLAB_EMAIL:-"gitlab@$GITLAB_HOST"}
GITLAB_PROJECT_LIMIT=${GITLAB_PROJECT_LIMIT:-10}
GITLAB_CAN_CREATE_GROUP=${GITLAB_CAN_CREATE_GROUP:-true}
GITLAB_USERNAME_CHANGING_ENABLED=${GITLAB_USERNAME_CHANGING_ENABLED:-true}
GITLAB_DEFAULT_THEME=${GITLAB_DEFAULT_THEME:-2}
GITLAB_SIGNUP_ENABLED=${GITLAB_SIGNUP_ENABLED:-false}
GITLAB_SIGNIN_ENABLED=${GITLAB_SIGNIN_ENABLED:-true}
GITLAB_WEBHOOK_TIMEOUT=${GITLAB_WEBHOOK_TIMEOUT:-10}
GITLAB_GRAVATAR_ENABLED=${GITLAB_GRAVATAR_ENABLED:-true}
GITLAB_BACKUP_TIME=${GITLAB_BACKUP_TIME:-0}
GITLAB_GIT_MAXSIZE=${GITLAB_GIT_MAXSIZE:-20971520}
GITLAB_GIT_TIMEOUT=${GITLAB_GIT_TIMEOUT:-10}
GITLAB_UNICORN_WORKER=${GITLAB_UNICORN_WORKER:-2}
GITLAB_UNICORN_TIMEOUT=${GITLAB_UNICORN_TIMEOUT:-300}

GITLAB_SMTP_DOMAIN=${GITLAB_SMTP_DOMAIN:-www.gmail.com}
GITLAB_SMTP_HOST=${GITLAB_SMTP_HOST:-smtp.gmail.com}
GITLAB_SMTP_PORT=${GITLAB_SMTP_PORT:-587}
GITLAB_SMTP_USER=${GITLAB_SMTP_USER:-}
GITLAB_SMTP_PASS=${GITLAB_SMTP_PASS:-}
GITLAB_SMTP_OPENSSL_VERIFY_MODE=${GITLAB_SMTP_OPENSSL_VERIFY_MODE:-PEER}
GITLAB_SMTP_STARTTLS=${GITLAB_SMTP_STARTTLS:-true}
GITLAB_SMTP_CA_PATH=${GITLAB_SMTP_CA_PATH:-/etc/ssl/certs}
GITLAB_SMTP_CA_FILE=${GITLAB_SMTP_CA_FILE:-/etc/ssl/certs/ca-certificates.crt}
if [ -n "${GITLAB_SMTP_USER}" ]; then
  GITLAB_SMTP_ENABLED=${GITLAB_SMTP_ENABLED:-true}
  GITLAB_SMTP_AUTHENTICATION=${GITLAB_SMTP_AUTHENTICATION:-login}
fi
GITLAB_SMTP_ENABLED=${GITLAB_SMTP_ENABLED:-false}


echo "Setting up gitlab directories."
chown gitlab:gitlab "$GITLAB_DATA_DIR"
mkdir -p ${GITLAB_DATA_DIR}/repositories
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/repositories
chmod -R ug+rwX,o-rwx ${GITLAB_DATA_DIR}/repositories/
chmod -R ug-s ${GITLAB_DATA_DIR}/repositories/
find ${GITLAB_DATA_DIR}/repositories/ -type d -print0 | sudo xargs -0 chmod g+s

mkdir -p ${GITLAB_DATA_DIR}/backup
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/backup
mkdir -p ${GITLAB_DATA_DIR}/satellites
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/satellites
chmod u+rwx,g=rx,o-rwx ${GITLAB_DATA_DIR}/satellites

mkdir -p ${GITLAB_DATA_DIR}/repositories
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/repositories

mkdir -p ${GITLAB_DATA_DIR}/gitlab
mkdir -p ${GITLAB_DATA_DIR}/gitlab/uploads
# Legacy folder setup migration
[ -d $GITLAB_DATA_DIR/uploads ] && mv -f $GITLAB_DATA_DIR/uploads $GITLAB_DATA_DIR/gitlab/
ln -sf ${GITLAB_DATA_DIR}/gitlab/uploads /usr/share/webapps/gitlab/public

mkdir -p ${GITLAB_DATA_DIR}/gitlab/assets
# Legacy folder setup migration
[ -d $GITLAB_DATA_DIR/assets ] && mv -f $GITLAB_DATA_DIR/assets $GITLAB_DATA_DIR/gitlab/
ln -sf ${GITLAB_DATA_DIR}/gitlab/assets /usr/share/webapps/gitlab/public

mkdir -p ${GITLAB_DATA_DIR}/gitlab/tmp
# Legacy folder setup migration
[ -d $GITLAB_DATA_DIR/tmp ] && mv -f $GITLAB_DATA_DIR/tmp $GITLAB_DATA_DIR/gitlab/
ln -sf ${GITLAB_DATA_DIR}/gitlab/tmp /usr/share/webapps/gitlab
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/gitlab

mkdir -p /run/gitlab
chown -R gitlab:gitlab /run/gitlab

# Legacy folder setup migration
[ -d ${GITLAB_DATA_DIR}/.ssh ] && [ ! -L ${GITLAB_DATA_DIR}/.ssh ] && mv ${GITLAB_DATA_DIR}/.ssh ${GITLAB_DATA_DIR}/gitlab/ssh

mkdir -p ${GITLAB_DATA_DIR}/gitlab/ssh
touch ${GITLAB_DATA_DIR}/gitlab/ssh/authorized_keys
chmod 700 ${GITLAB_DATA_DIR}/gitlab/ssh
chmod 600 ${GITLAB_DATA_DIR}/gitlab/ssh/authorized_keys
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/gitlab/ssh

ln -sf ${GITLAB_DATA_DIR}/gitlab/ssh ${GITLAB_DATA_DIR}/.ssh
ln -sf ${GITLAB_DATA_DIR}/gitlab/ssh ${GITLAB_INSTALL_DIR}/.ssh

mkdir -p ${GITLAB_DATA_DIR}/log/gitlab
mkdir -p ${GITLAB_DATA_DIR}/log/gitlab-shell
rm -rf ${GITLAB_INSTALL_DIR}/log
chown -R gitlab:gitlab ${GITLAB_DATA_DIR}/log

usermod -d ${GITLAB_DATA_DIR} gitlab

echo "Configuring gitlab"
sed -i 's,{{GITLAB_DATA_DIR}},'"${GITLAB_DATA_DIR}"',g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_HOST}}/'"${GITLAB_HOST}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_PORT}}/'"${GITLAB_PORT}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_HTTPS}}/'"${GITLAB_HTTPS}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_EMAIL}}/'"${GITLAB_EMAIL}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_PROJECT_LIMIT}}/'"${GITLAB_PROJECT_LIMIT}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_CAN_CREATE_GROUP}}/'"${GITLAB_CAN_CREATE_GROUP}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_USERNAME_CHANGING_ENABLED}}/'"${GITLAB_USERNAME_CHANGING_ENABLED}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_DEFAULT_THEME}}/'"${GITLAB_DEFAULT_THEME}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_SIGNUP_ENABLED}}/'"${GITLAB_SIGNUP_ENABLED}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_SIGNIN_ENABLED}}/'"${GITLAB_SIGNIN_ENABLED}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_WEBHOOK_TIMEOUT}}/'"${GITLAB_WEBHOOK_TIMEOUT}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_GRAVATAR_ENABLED}}/'"${GITLAB_GRAVATAR_ENABLED}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_BACKUP_TIME}}/'"${GITLAB_BACKUP_TIME}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_GIT_MAXSIZE}}/'"${GITLAB_GIT_MAXSIZE}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"
sed -i 's/{{GITLAB_GIT_TIMEOUT}}/'"${GITLAB_GIT_TIMEOUT}"'/g' "${GITLAB_CONFIG_DIR}/gitlab.yml"


echo "Configuring database.yml"
sed -i 's/{{POSTGRES_DATABASE_ENCODING}}/'"${POSTGRES_DATABASE_ENCODING}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_NAME}}/'"${POSTGRES_DATABASE_NAME}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_POOL}}/'"${POSTGRES_DATABASE_POOL}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_USER}}/'"${POSTGRES_DATABASE_USER}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_PASSWORD}}/'"${POSTGRES_DATABASE_PASSWORD}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_HOST}}/'"${POSTGRES_DATABASE_HOST}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"
sed -i 's/{{POSTGRES_DATABASE_PORT}}/'"${POSTGRES_DATABASE_PORT}"'/g' "${GITLAB_CONFIG_DIR}/database.yml"

echo "Configuring gitlab-shell"
sed -i 's/{{REDIS_HOST}}/'"${GL_REDIS_HOST}"'/g' "${GITSHELL_CONFIG_DIR}/config.yml"
sed -i 's/{{REDIS_PORT}}/'"${GL_REDIS_PORT}"'/g' "${GITSHELL_CONFIG_DIR}/config.yml"
sed -i 's,{{GITLAB_DATA_DIR}},'"${GITLAB_DATA_DIR}"',g' "${GITSHELL_CONFIG_DIR}/config.yml"

echo "Configuring resque.yml"
ln -sf "${GITLAB_CONFIG_DIR}/resque.yml" "${GITLAB_INSTALL_DIR}/config/resque.yml"
sed -i 's/{{REDIS_HOST}}/'"${GL_REDIS_HOST}"'/g' "${GITLAB_CONFIG_DIR}/resque.yml"
sed -i 's/{{REDIS_PORT}}/'"${GL_REDIS_PORT}"'/g' "${GITLAB_CONFIG_DIR}/resque.yml"

echo "Configuring unicorn"
sed -i 's,{{GITLAB_DATA_DIR}},'"${GITLAB_DATA_DIR}"',g' "${GITLAB_CONFIG_DIR}/unicorn.rb"
sed -i 's/{{GITLAB_UNICORN_WORKER}}/'"${GITLAB_UNICORN_WORKER}"'/g' "${GITLAB_CONFIG_DIR}/unicorn.rb"
sed -i 's/{{GITLAB_UNICORN_TIMEOUT}}/'"${GITLAB_UNICORN_TIMEOUT}"'/g' "${GITLAB_CONFIG_DIR}/unicorn.rb"

if [ "$GITLAB_SMTP_ENABLED" = "true" ]; then
  echo "Configuring smtp"
  ln -sf "${GITLAB_CONFIG_DIR}/smtp_settings.rb" "${GITLAB_INSTALL_DIR}/config/initializers/"
  sed -i 's/{{GITLAB_SMTP_HOST}}/'"${GITLAB_SMTP_HOST}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_PORT}}/'"${GITLAB_SMTP_PORT}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_USER}}/'"${GITLAB_SMTP_USER}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_PASS}}/'"${GITLAB_SMTP_PASS}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_DOMAIN}}/'"${GITLAB_SMTP_DOMAIN}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_AUTHENTICATION}}/'"${GITLAB_SMTP_AUTHENTICATION}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_OPENSSL_VERIFY_MODE}}/'"${GITLAB_SMTP_OPENSSL_VERIFY_MODE}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's/{{GITLAB_SMTP_STARTTLS}}/'"${GITLAB_SMTP_STARTTLS}"'/g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's,{{GITLAB_SMTP_CA_PATH}},'"${GITLAB_SMTP_CA_PATH}"',g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
  sed -i 's,{{GITLAB_SMTP_CA_FILE}},'"${GITLAB_SMTP_CA_FILE}"',g' "${GITLAB_CONFIG_DIR}/smtp_settings.rb"
fi



echo "Generating SSH host keys"
mkdir -p "${GITLAB_DATA_DIR}/ssh"
[ -e "${GITLAB_DATA_DIR}/ssh/ssh_host_key" ] || ssh-keygen -q -f "${GITLAB_DATA_DIR}/ssh/ssh_host_key" -N '' -t rsa1
[ -e "${GITLAB_DATA_DIR}/ssh/ssh_host_rsa_key" ] || ssh-keygen -q -f "${GITLAB_DATA_DIR}/ssh/ssh_host_rsa_key" -N '' -t rsa
[ -e "${GITLAB_DATA_DIR}/ssh/ssh_host_dsa_key" ] || ssh-keygen -q -f "${GITLAB_DATA_DIR}/ssh/ssh_host_dsa_key" -N '' -t dsa
[ -e "${GITLAB_DATA_DIR}/ssh/ssh_host_ecdsa_key" ] || ssh-keygen -q -f "${GITLAB_DATA_DIR}/ssh/ssh_host_ecdsa_key" -N '' -t ecdsa
[ -e "${GITLAB_DATA_DIR}/ssh/ssh_host_ed25519_key" ] || ssh-keygen -q -f "${GITLAB_DATA_DIR}/ssh/ssh_host_ed25519_key" -N '' -t ecdsa
sed -i 's,#HostKey /etc/ssh/,HostKey '"${GITLAB_DATA_DIR}"'/ssh/,g' -i /etc/ssh/sshd_config

cd "$GITLAB_INSTALL_DIR"


echo "Verifying database settings"
timeout=60

export PGPASSWORD="$POSTGRES_DATABASE_PASSWORD"

while ! psql -h $POSTGRES_DATABASE_HOST -U $POSTGRES_DATABASE_USER -d $POSTGRES_DATABASE_NAME -c "" 2>/dev/null ; do
  timeout=$((timeout-1))
  if [ $timeout -eq 0 ]; then
    echo "Could not connect to database. Aborting." 1>&2
    exit 1
  fi
  sleep 1
done

QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';"
COUNT=$(psql -h $POSTGRES_DATABASE_HOST -U $POSTGRES_DATABASE_USER -d $POSTGRES_DATABASE_NAME -Atw -c "${QUERY}" 2>/dev/null)

[ ! -e "$GITLAB_DATA_DIR/GITLAB_VERSION" ] && touch "$GITLAB_DATA_DIR/GITLAB_VERSION"
CURRENT_VERSION=$(cat "$GITLAB_DATA_DIR/GITLAB_VERSION")
CURRENT_VERSION=${CURRENT_VERSION:-unknown}
INSTALLED_VERSION=$(cat "$GITLAB_INSTALL_DIR/VERSION")

if [ -z "${COUNT}" -o ${COUNT} -eq 0 ]; then
  echo "Setting up GitLab database."
  sudo -u gitlab -H force=yes bundle exec rake gitlab:setup RAILS_ENV=production >/dev/null
fi


if [ "$CURRENT_VERSION" != "$INSTALLED_VERSION" ]; then
  echo "Migrating GitLab from version $CURRENT_VERSION to $INSTALLED_VERSION"

  sudo -u gitlab -H bundle exec rake gitlab:backup:create RAILS_ENV=production
  sudo -u gitlab -H bundle exec rake db:migrate RAILS_ENV=production
  
  rm -rf "${GITLAB_DATA_DIR}/gitlab/tmp/*"
  mkdir -p "${GITLAB_DATA_DIR}/gitlab/tmp/cache/"
  mkdir -p "${GITLAB_DATA_DIR}/gitlab/tmp/public/assets/"
  chown -R gitlab:gitlab "${GITLAB_DATA_DIR}/gitlab/tmp"

  sudo -u gitlab -H bundle exec rake assets:clean RAILS_ENV=production >/dev/null
  sudo -u gitlab -H bundle exec rake assets:precompile RAILS_ENV=production >/dev/null
  echo "$INSTALLED_VERSION" > "${GITLAB_DATA_DIR}/GITLAB_VERSION"
  
  echo "Finished migration"
fi

rm -rf tmp/pids/unicorn.pid
rm -rf tmp/pids/sidekiq.pid
rm -rf tmp/sockets/gitlab.socket

sudo -u gitlab -H bundle exec rake gitlab:satellites:create RAILS_ENV=production >/dev/null

echo "Configuring git for the gitlab user"
sudo -u gitlab -H "/usr/bin/git" config --global user.name  "GitLab"
sudo -u gitlab -H "/usr/bin/git" config --global user.email "gitlab@kampka.net"
sudo -u gitlab -H "/usr/bin/git" config --global core.autocrlf "input"

echo "Creating secrets files"

if [ ! -e ${GITLAB_DATA_DIR}/gitlab/gitlab_secret ]; then
  touch ${GITLAB_DATA_DIR}/gitlab/gitlab_secret
  chown gitlab:gitlab ${GITLAB_DATA_DIR}/gitlab/gitlab_secret
  echo "$(uuidgen)$(date)" | base64 > ${GITLAB_DATA_DIR}/gitlab/gitlab_secret
fi
ln -sf ${GITLAB_DATA_DIR}/gitlab/gitlab_secret ${GITLAB_INSTALL_DIR}/.secret

if [ ! -e ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret ]; then
  touch ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret
  chown gitlab:gitlab ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret
  echo "$(uuidgen)$(date)" | base64 > ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret
fi
ln -sf ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret ${GITLAB_INSTALL_DIR}/.gitlab_shell_secret
ln -sf ${GITLAB_DATA_DIR}/gitlab/gitlab_shell_secret ${GITLAB_SHELL_INSTALL_DIR}/.gitlab_shell_secret

echo "Rebuilding .authorized_keys file"

cd ${GITLAB_INSTALL_DIR}
sudo -u gitlab -H force=yes bundle exec rake gitlab:shell:setup RAILS_ENV=production >/dev/null

echo "Init Gitlab complete"
