# osm2pgsql styles for openstreetmap.ie

default.style.IE: adds support for name:ga and political_division

## initial import

```bash
osm2pgsql \
  --database gis \
  --create \
  --slim \
  --multi-geometry \
  --hstore \
  --tag-transform-script /data/src/openstreetmap-carto/openstreetmap-carto.lua \
  --cache 2500 \
  --number-processes 1 \
  --style /usr/local/share/osm2pgsql/default.style.IE \
  /home/roles/planet/data/ireland-and-northern-ireland-2019-11-23T21\:19\:02Z.osm.pbf
```
