select count(*) as counter, 'constant_data.ne_50m_admin_0_countries'       as tablename from constant_data.ne_50m_admin_0_countries       union all
select count(*) as counter, 'constant_data.ne_50m_populated_places'       as tablename from constant_data.ne_50m_populated_places       union all
select count(*) as counter, 'osm_data.addr_number'       as tablename from osm_data.addr_number       union all
select count(*) as counter, 'osm_data.amen_education' 	as tablename from osm_data.amen_education	  union all
select count(*) as counter, 'osm_data.amen_health'       as tablename from osm_data.amen_health	      union all
select count(*) as counter, 'osm_data.amen_restaurant'   as tablename from osm_data.amen_restaurant   union all
select count(*) as counter, 'osm_data.base_aeroway'      as tablename from osm_data.base_aeroway	  union all
select count(*) as counter, 'osm_data.base_boundary'     as tablename from osm_data.base_boundary	  union all
select count(*) as counter, 'osm_data.base_building'     as tablename from osm_data.base_building	  union all
select count(*) as counter, 'osm_data.base_highway'      as tablename from osm_data.base_highway	  union all
select count(*) as counter, 'osm_data.shop_car'          as tablename from osm_data.shop_car	      union all
select count(*) as counter, 'osm_data.shop_cloth'        as tablename from osm_data.shop_cloth	      union all
select count(*) as counter, 'osm_data.shop_computer'     as tablename from osm_data.shop_computer     union all
select count(*) as counter, 'osm_data.shop_supermarket'  as tablename from osm_data.shop_supermarket


241	constant_data.ne_50m_admin_0_countries
1249	constant_data.ne_50m_populated_places
1494073	osm_data.addr_number
7113	osm_data.amen_education
14960	osm_data.amen_health
37876	osm_data.amen_restaurant
2514	osm_data.base_aeroway
10211	osm_data.base_boundary
11300026	osm_data.base_building
302005	osm_data.base_highway
4952	osm_data.shop_car
7736	osm_data.shop_cloth
567	osm_data.shop_computer
9808	osm_data.shop_supermarket