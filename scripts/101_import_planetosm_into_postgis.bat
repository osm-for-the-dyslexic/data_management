rem osm2pgsql.exe -H localhost -d osm -U postgres -s -G -k -C 800 -S C:\temp\default.style c:\temp\cyprus-latest.osm
rem -H postgres host
rem -d postgres database
rem -U posgres username
rem -s Store temporary data in the database. This greatly reduces the RAM usage but is much slower. This switch is required if you want to update with --append later.
rem -G create multygeometries features in tables
rem -k add tags as key/value store
rem -C 800 800MB caching for nodes
rem -S filename location of the syle
rem the default is -c (create, removing existing data) use -a to append data
rem osm2pgsql.exe --help

rem africa
rem ..\osm2pgsql_x64\osm2pgsql.exe -c -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\africa-latest.osm.pbf

rem antarctica
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\antarctica-latest.osm.pbf

rem asia
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\asia-latest.osm.pbf

rem australia-oceania
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\australia-oceania-latest.osm.pbf

rem central-america
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\central-america-latest.osm.pbf

rem europe
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\europe-latest.osm.pbf
rem ..\programs\osm2pgsql_x64\osm2pgsql.exe -c -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\europe-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -c -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\iceland-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\italy-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\france-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\switzerland-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\germany-latest.osm.pbf
..\programs\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\programs\osm2pgsql_x64\default.style C:\osm4dys\osm_data\austria-latest.osm.pbf




rem north-america
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\north-america-latest.osm.pbf

rem south-america
rem ..\osm2pgsql_x64\osm2pgsql.exe -a -H localhost -d planetosm -U postgres -s -G -k -C 800 -S ..\osm2pgsql_x64\default.style C:\osm4dys\osm_data\south-america-latest.osm.pbf

pause

rem select name,tags,way
rem from planet_osm_point
rem where amenity = 'restaurant'
rem select *
rem from planet_osm_polygon
rem where boundary = 'administrative'
rem select building,tags,way
rem from planet_osm_polygon
rem where building is not null
rem limit 1000


rem http://download.geofabrik.de/