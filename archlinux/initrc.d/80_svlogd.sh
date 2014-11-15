#!/bin/bash

set -e

DEFAULT_SVLOG_CONFIG=${DEFAULT_SVLOG_CONFIG:-/etc/svlog.d/config.default}
DEFAULT_SVLOG_RUN=${DEFAULT_SVLOG_RUN:-/etc/svlog.d/log.run}

# see svlogd(8)
SVLOG_SIZE=${SVLOG_SIZE:-}
SVLOG_NUM=${SVLOG_NUM:-}
SVLOG_MIN=${SVLOG_MIN:-}
SVLOG_TIMEOUT=${SVLOG_TIMEOUT:-}
SVLOG_PROCESSOR=${SVLOG_PROCESSOR:-}
SVLOG_UDP=${SVLOG_UDP:-}
SVLOG_UDP_ONLY=${SVLOG_UDP_ONLY:-}
SVLOG_PREFIX=${SVLOG_PREFIX:-}

for dir in /services/*; do
  if [ -d "$dir" ] && [ -x "$dir/run" ]; then
    LOG_RUN="$dir/log/run"
    LOG_CONF="$dir/log/config"

    mkdir -p "$dir/log"
    if [ ! -x "$LOG_RUN" ]; then
      ln -s "${DEFAULT_SVLOG_RUN}" "$LOG_RUN"
    fi
    if [ ! -e "$LOG_CONG" ] && [ -e "${DEFAULT_SVLOG_CONFIG}" ]; then
      cp "${DEFAULT_SVLOG_CONFIG}" "$LOG_CONF"
    fi
    touch "$LOG_CONF"
    [ -n "$SVLOG_SIZE" ] && ! grep -q "^s" "$LOG_CONF" && echo "s${SVLOG_SIZE}" >> "$LOG_CONF"
    [ -n "$SVLOG_NUM" ] && ! grep -q "^n" "$LOG_CONF" && echo "n${SVLOG_NUM}" >> "$LOG_CONF"
    [ -n "$SVLOG_MIN" ] && ! grep -q "^N" "$LOG_CONF" && echo "N${SVLOG_MIN}" >> "$LOG_CONF"
    [ -n "$SVLOG_TIMEOUT" ] && ! grep -q "^t" "$LOG_CONF" && echo "t${SVLOG_TIMEOUT}" >> "$LOG_CONF"
    [ -n "$SVLOG_PROCESSOR" ] && ! grep -q "^!" "$LOG_CONF" && echo "!${SVLOG_PROCESSOR}" >> "$LOG_CONF"
    [ -n "$SVLOG_UDP" ] && ! grep -q "^u" "$LOG_CONF" && echo "u${SVLOG_UDP}" >> "$LOG_CONF"
    [ -n "$SVLOG_UDP_ONLY" ] && ! grep -q "^U" "$LOG_CONF" && echo "U${SVLOG_UDP_ONLY}" >> "$LOG_CONF"
    [ -n "$SVLOG_PREFIX" ] && ! grep -q "^p" "$LOG_CONF" && echo "p${SVLOG_PREFIX}" >> "$LOG_CONF"
  fi
done 

exit 0
