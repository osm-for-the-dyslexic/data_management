@echo off

echo ne_50m_admin_0_countries
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','constant_data.ne_50m_admin_0_countries'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo ne_50m_populated_places
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','constant_data.ne_50m_populated_places'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo addr_number
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.addr_number'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo amen_education
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.amen_education'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo amen_health
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.amen_health'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo amen_restaurant
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.amen_restaurant'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo base_aeroway
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.base_aeroway'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo base_highway
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.base_highway'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo base_boundary
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.base_boundary'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo shop_car
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.shop_car'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo shop_cloth
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.shop_cloth'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo shop_computer
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.shop_computer'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo shop_supermarket
echo SELECT manager.table2jsonset('C:/osm4dys/Website/data','osm_data.shop_supermarket'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo DONE
pause