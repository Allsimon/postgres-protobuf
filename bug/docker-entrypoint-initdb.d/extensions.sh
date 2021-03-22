#!/usr/bin/env bash
echo "Installing pg_stat_statements extension"
cat > $PGDATA/postgresql.conf <<- EOM
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.max = 10000
pg_stat_statements.track = all
# See https://www.postgresql.org/docs/12/populate.html#POPULATE-PG-DUMP
# Those values are not recommended for production, but locally we can ignore problems if the server crash
# Before setting those values, a prod restore would take ~1h30, after it takes ~15min
work_mem = 32MB
shared_buffers = 2GB
maintenance_work_mem = 2GB
wal_level = minimal
full_page_writes = off
max_wal_senders = 0
wal_buffers = -1
listen_addresses = '*'
EOM
