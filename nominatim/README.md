# nominatim.openstreetmap.ie

Instructions recovered from dev3.openstreetmap.ie:/home/roles/nominatim/import/README_UPDATE_NOMINATIM.txt

## Initial Import

To manually update nominatim follows these steps (takes about 65 minutes):

1. `screen`

2. `sudo -u nominatim -i`

3. `cd app/Nominatim/utils`

4. `dropdb nominatim`

5. ```
   /usr/bin/time \
   ./setup.php \
     --no-partitions \
     --all \
     --osm2pgsql-cache 1000 \
     --osm-file ~/import/ireland-and-northern-ireland-latest.osm.pbf \
    2>&1 | tee setup.log`

   128.70user 78.00system 1:04:44elapsed 5%CPU (0avgtext+0avgdata 2367488maxresident)k
   ```

6. ```
   ./specialphrases.php --countries > countries.sql
   psql -d nominatim -f countries.sql
   ````

7. ```
   ./specialphrases.php --wiki-import > wiki.sql
   psql nominatim -f wiki.sql
   ```

8. update the import date

   ```
   # DBDATE=$(sqlite3 /home/roles/taginfo/app/data/taginfo-db.db "select strftime('%Y-%m-%dT%H:%M:%SZ',data_until) from source where id = 'db'")
   # echo "delete from import_status; insert into import_status (lastimportdate) values ('$DBDATE')"  | psql nominatim
   ```
 
## Setup daily diffs

```bash
rm ~nominatim/import/settings/configuration.txt 
./setup.php --osmosis-init

./setup.php --create-functions --enable-diff-updates
```

## Process daily diffs

```
cd ~nominatim/import
./utils/update.php  \
  --import-osmosis-all \
  --no-npi \
  --osm2pgsql-cache 500 | tee log/import-osmosis.log &
```

## DELETE OLD place_ids

Not quite sure what this about but leaving it in here [dh - 20191124]

```
select place_force_delete(PLACEID)
```

http://nominatim.openstreetmap.ie/details.php?osmid=433249&osmtype=R

