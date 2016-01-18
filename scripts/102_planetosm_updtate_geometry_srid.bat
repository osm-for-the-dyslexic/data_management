@echo off
echo UpdateGeometrySRID to 3857
pause
echo SELECT UpdateGeometrySRID('planet_osm_line','way',3857);    | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d planetosm -U postgres
echo SELECT UpdateGeometrySRID('planet_osm_point','way',3857);   | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d planetosm -U postgres
echo SELECT UpdateGeometrySRID('planet_osm_polygon','way',3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d planetosm -U postgres
echo SELECT UpdateGeometrySRID('planet_osm_roads','way',3857);   | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d planetosm -U postgres
echo DONE
pause

