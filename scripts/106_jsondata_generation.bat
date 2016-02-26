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


rem select count(*) as counter, 'constant_data.ne_50m_admin_0_countries'       as tablename from constant_data.ne_50m_admin_0_countries       union all
rem select count(*) as counter, 'constant_data.ne_50m_populated_places'       as tablename from constant_data.ne_50m_populated_places       union all
rem select count(*) as counter, 'osm_data.addr_number'       as tablename from osm_data.addr_number       union all
rem select count(*) as counter, 'osm_data.amen_education' 	as tablename from osm_data.amen_education	  union all
rem select count(*) as counter, 'osm_data.amen_health'       as tablename from osm_data.amen_health	      union all
rem select count(*) as counter, 'osm_data.amen_restaurant'   as tablename from osm_data.amen_restaurant   union all
rem select count(*) as counter, 'osm_data.base_aeroway'      as tablename from osm_data.base_aeroway	  union all
rem select count(*) as counter, 'osm_data.base_boundary'     as tablename from osm_data.base_boundary	  union all
rem select count(*) as counter, 'osm_data.base_building'     as tablename from osm_data.base_building	  union all
rem select count(*) as counter, 'osm_data.base_highway'      as tablename from osm_data.base_highway	  union all
rem select count(*) as counter, 'osm_data.shop_car'          as tablename from osm_data.shop_car	      union all
rem select count(*) as counter, 'osm_data.shop_cloth'        as tablename from osm_data.shop_cloth	      union all
rem select count(*) as counter, 'osm_data.shop_computer'     as tablename from osm_data.shop_computer     union all
rem select count(*) as counter, 'osm_data.shop_supermarket'  as tablename from osm_data.shop_supermarket


