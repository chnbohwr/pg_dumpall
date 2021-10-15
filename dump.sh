#!/bin/bash

set -e -u

echo "Delete Expired Data $EXPIRE_DAYS"
find /dump -mtime +$EXPIRE_DAYS -type f -delete

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/dump-$DATE.sql"

pg_dumpall -h $PGHOST -U "$PGUSER" -f "$FILE"
gzip "$FILE"

echo "Job finished: $(date)"
