#!/usr/bin/env bash

test "$1" || exec 2>>//data/imports/logs/osmosis-update-$(date -u --iso-8601=seconds).log
set -euf -o pipefail

UPDATE_USER=imports

WORKOSM_DIR=/data/imports/osmosisworkingdir
OSMCARTO_DIR=/data/src/openstreetmap-carto

OSM2PGSQL_BINARY=/usr/local/bin/osm2pgsql
OSMOSIS_BINARY=/usr/bin/osmosis
RENDEREXPIRED_BINARY=/usr/local/bin/render_expired
TRIMOSC_BINARY=/data/imports/bin/trim_osc.py

POLY_FILE=/data/planet/www/ireland-and-northern-ireland.poly

EXPIRY_MINZOOM=10
EXPIRY_MAXZOOM=20
EXPIRY_METAZOOM=15
EXPIRY_FILE=dirty_tiles

cd ${WORKOSM_DIR}

${OSMOSIS_BINARY} --read-replication-interval workingDirectory="${WORKOSM_DIR}" --simplify-change --write-xml-change ${WORKOSM_DIR}/osmChange

${TRIMOSC_BINARY} -d gis --user ${UPDATE_USER} --poly "${POLY_FILE}" ${WORKOSM_DIR}/osmChange ${WORKOSM_DIR}osmChange

${OSM2PGSQL_BINARY} \
  --database gis \
  --append \
  --slim \
  --multi-geometry \
  --hstore \
  --tag-transform-script /data/src/openstreetmap-carto/openstreetmap-carto.lua \
  --cache 300 \
  --style /usr/local/share/osm2pgsql/default.style.IE \
  --expire-tiles ${EXPIRY_METAZOOM}:${EXPIRY_METAZOOM} \
  --expire-output "${EXPIRY_FILE}.$$"
  ${WORKOSM_DIR}/osmChange

${RENDEREXPIRED_BINARY} \
  --min-zoom=${EXPIRY_MINZOOM} \
  --max-zoom=${EXPIRY_MAXZOOM} \
  --touch-from=${EXPIRY_MINZOOM} \
  --socket=/var/run/renderd.sock < "${EXPIRY_FILE}.$$"

rm ${WORKOSM_DIR}/osmChange

