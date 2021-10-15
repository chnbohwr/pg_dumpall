#!/bin/bash

set -e

COMMAND=${1:-dump}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
PGUSER=${PGUSER:-postgres}
PGHOST=${PGHOST:-localhost}
EXPIRE_DAYS=${EXPIRE_DAYS:-10}

if [[ "$COMMAND" == 'dump' ]]; then
    exec /dump.sh
elif [[ "$COMMAND" == 'dump-cron' ]]; then
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="PGUSER='$PGUSER'\nPGHOST='$PGHOST'\nEXPIRE_DAYS='$EXPIRE_DAYS'"
    if [ -n "$PGPASSWORD" ]; then
        CRON_ENV="$CRON_ENV\nPGPASSWORD='$PGPASSWORD'"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
else
    echo "Unknown command $COMMAND"
    echo "Available commands: dump, dump-cron"
    exit 1
fi
