#!/bin/bash

export PGPASS=$POSTGRES_PASSWORD
export PGPASSWORD=$POSTGRES_PASSWORD

if [[ -z $IMPORT_FILE ]]; then
    IMPORT_FILE=/tmp/data.osm.pbf
    wget -O $IMPORT_FILE $PBF_URL
fi

if ! [[ -f $IMPORT_FILE ]]; then
    echo "IMPORT_FILE isn't available: $IMPORT_FILE"
    exit 1
fi

osm2pgsql --username $POSTGRES_USER \
    --database $POSTGRES_DB \
    --host $POSTGRES_HOST \
    --port $POSTGRES_PORT \
    --create \
    --slim \
    -G \
    --hstore \
    --tag-transform-script /usr/local/src/openstreetmap-carto/openstreetmap-carto.lua \
    -C 2048 \
    --number-processes ${THREADS:-4} \
    -S /usr/local/src/openstreetmap-carto/openstreetmap-carto.style \
    $IMPORT_FILE
