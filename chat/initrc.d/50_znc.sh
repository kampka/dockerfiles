#!/bin/bash

set -e

mkdir -p /data/znc

[ -e /etc/znc.conf ] && . /etc/znc.conf

ZNC_DATA_DIR=${ZNC_DATA_DIR:-/data/znc}

[ -d "${ZNC_DATA_DIR}" ] || mkdir -p "${ZNC_DATA_DIR}"
[ -e "${ZNC_DATA_DIR}/znc.conf" ] && . "${ZNC_DATA_DIR}/znc.conf"

usermod -d "${ZNC_DATA_DIR}" znc &>/dev/null

ZNC_CONFIG="${ZNC_DATA_DIR}/configs/znc.conf"
ZNC_PORT=${ZNC_PORT:-6662}
ZNC_IPV4=${ZNC_IPV4:-true}
ZNC_IPV6=${ZNC_IPV6:-true}
ZNC_SSL=${ZNC_SSL:-true}

if [ ! -e ${ZNC_CONFIG} ]; then
  cp -r /etc/znc/* /data/znc
  sed -i 's/{{ZNC_PORT}}/'"${ZNC_PORT}"'/g' ${ZNC_CONFIG}
  sed -i 's/{{ZNC_IPV4}}/'"${ZNC_IPV4}"'/g' ${ZNC_CONFIG}
  sed -i 's/{{ZNC_IPV6}}/'"${ZNC_IPV6}"'/g' ${ZNC_CONFIG}
  sed -i 's/{{ZNC_SSL}}/'"${ZNC_SSL}"'/g' ${ZNC_CONFIG}
fi

chown -R znc:znc /data/znc

if [ "${ZNC_SSL}" = "true" ] && [ ! -e "${ZNC_DATA_DIR}/znc.pem" ]; then
  chpst -u znc:znc /usr/bin/znc --makepem --datadir "${ZNC_DATA_DIR}"
fi

exit 0
