chnbohwr/pg_dumpall
================

Docker image with pg_dumpall running as a cron task

### Usage

Attach a target postgres container to this container and mount a volume to container's `/dump` folder. Backups will appear in this volume. Optionally set up cron job schedule (default is `0 1 * * *` - runs every day at 1:00 am).

```
docker run -d \
    -v /path/to/target/folder:/dump \   # where to put db dumps
    -e CRON_SCHEDULE='0 1 * * *' \      # cron job schedule
    -e PGUSER=postgres \
    -e PGPASSWORD=mysecretpassword \
    -e PGHOST=localhost \   # linked container with running mongo
    -e EXPIRE_DAYS=10
    chnbohwr/pg_dumpall dump-cron
```

to restore data use 
```
 psql -f dump-20211014_140501.sql -U postgres
```