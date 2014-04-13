#!/bin/bash
set -e

POSTGRESQL_USER=${POSTGRESQL_USER:-"docker"}
POSTGRESQL_PASS=${POSTGRESQL_PASS:-"docker"}
POSTGRESQL_DB=${POSTGRESQL_DB:-"docker"}
POSTGRESQL_TEMPLATE=${POSTGRESQL_TEMPLATE:-"DEFAULT"}

POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin
POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.3/main/postgresql.conf
POSTGRESQL_DATA=/data
    
if find $POSTGRESQL_DATA -maxdepth 0 -empty | read v; then
    mkdir -p $POSTGRESQL_DATA
    chown -R postgres:postgres $POSTGRESQL_DATA
    sudo -u postgres $POSTGRESQL_BIN/initdb -D $POSTGRESQL_DATA
    sudo -u postgres $POSTGRESQL_BIN/postgres --single --config-file=$POSTGRESQL_CONFIG_FILE <<< "CREATE USER $POSTGRESQL_USER WITH SUPERUSER;"
    sudo -u postgres $POSTGRESQL_BIN/postgres --single --config-file=$POSTGRESQL_CONFIG_FILE <<< "ALTER USER $POSTGRESQL_USER WITH PASSWORD '$POSTGRESQL_PASS';"
    sudo -u postgres $POSTGRESQL_BIN/postgres --single --config-file=$POSTGRESQL_CONFIG_FILE <<< "CREATE DATABASE $POSTGRESQL_DB OWNER $POSTGRESQL_USER;"
fi

sudo -u postgres $POSTGRESQL_BIN/postgres -D $POSTGRESQL_DATA -c config-file=$POSTGRESQL_CONFIG_FILE





