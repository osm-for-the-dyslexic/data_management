@echo off

echo truncate old data
pause
echo truncate osm_data.base_boundary;       | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.base_highway;        | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.base_building;       | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.base_aeroway;        | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.amen_restaurant;     | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.amen_health;         | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.amen_education;      | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.addr_number;         | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.shop_supermarket;    | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.shop_cloth;          | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.shop_car;            | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo truncate osm_data.shop_computer;       | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo vacuum full
echo vacuum full;                           | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo analyze
echo analyze;                               | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

pause
echo update osm4dys with fresh osm data
echo select manager.update_data_from_osm(); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo DONE
pause

