DROP FUNCTION IF EXISTS manager.update_data_from_osm();
CREATE OR REPLACE FUNCTION manager.update_data_from_osm()
    RETURNS text AS
$BODY$
    
DECLARE
    dblink_name text;
    remote_schema_name text;
    myRowCount int;

    base_boundary_attributes text[];
    base_boundary_table text;
    base_boundary_clause text;
    base_boundary_insert text;

    base_highway_attributes text[];
    base_highway_table text;
    base_highway_clause text;
    base_highway_insert text;
    
    base_building_attributes text[];
    base_building_table text;
    base_building_clause text;
    base_building_insert text;

    base_aeroway_attributes text[];
    base_aeroway_table text;
    base_aeroway_clause text;
    base_aeroway_insert text;
    
    amen_restaurant_attributes text[];
    amen_restaurant_table text;
    amen_restaurant_clause text;
    amen_restaurant_insert text;    
    
    amen_health_attributes text[];
    amen_health_table text;
    amen_health_clause text;
    amen_health_insert text;    

    amen_education_attributes text[];
    amen_education_table text;
    amen_education_clause text;
    amen_education_insert text;    

    addr_number_attributes text[];
    addr_number_table text;
    addr_number_clause text;
    addr_number_insert text;    

    shop_supermarket_attributes text[];
    shop_supermarket_table text;
    shop_supermarket_clause text;
    shop_supermarket_insert text;    

    shop_cloth_attributes text[];
    shop_cloth_table text;
    shop_cloth_clause text;
    shop_cloth_insert text;    

    shop_car_attributes text[];
    shop_car_table text;
    shop_car_clause text;
    shop_car_insert text;    

    shop_computer_attributes text[];
    shop_computer_table text;
    shop_computer_clause text;
    shop_computer_insert text;    
    
BEGIN
    dblink_name := 'dbname=planetosm port=5432 host=localhost user=postgres password=osm4dys';
    remote_schema_name := 'public';

    -----------------------------------------------------------------------------------------------
    -- base_boundary
    -----------------------------------------------------------------------------------------------
    -- select name,osm_id,admin_level,tags,way 
    -- from public.planet_osm_polygon 
    -- where boundary = 'administrative';    
    -----------------------------------------------------------------------------------------------
    base_boundary_attributes := '{name,osm_id,admin_level,tags,way}';
    base_boundary_table := 'planet_osm_polygon';
    base_boundary_clause := 'where boundary = ''''administrative''''';
    base_boundary_insert := 'INSERT INTO osm_data.base_boundary  (name,osm_id,admin_level,tags,way) ' 
                         || manager.get_remote_select(dblink_name,remote_schema_name,base_boundary_table,base_boundary_attributes,base_boundary_clause);
    EXECUTE base_boundary_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'base_boundary_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- base_highway
    -----------------------------------------------------------------------------------------------
    -- select name,osm_id,highway,surface,bridge,tunnel,tags,way 
    -- from public.planet_osm_roads
    -- where highway is not null    
    -----------------------------------------------------------------------------------------------
    base_highway_attributes := '{name,osm_id,highway,surface,bridge,tunnel,tags,way}';
    base_highway_table := 'planet_osm_roads';
    base_highway_clause := 'where highway is not null';
    base_highway_insert := 'INSERT INTO osm_data.base_highway (name,osm_id,highway,surface,bridge,tunnel,tags,way) ' 
                        || manager.get_remote_select(dblink_name,remote_schema_name,base_highway_table,base_highway_attributes,base_highway_clause);
    EXECUTE base_highway_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'base_highway_insert: % rows', myRowCount;
    
    -----------------------------------------------------------------------------------------------
    -- base_building
    -----------------------------------------------------------------------------------------------
    -- select osm_id,building,way 
    -- from public.planet_osm_polygon
    -- where building is not null    
    -----------------------------------------------------------------------------------------------
    base_building_attributes := '{osm_id,building,way}';
    base_building_table := 'planet_osm_polygon';
    base_building_clause := 'where building is not null';
    base_building_insert := 'INSERT INTO osm_data.base_building (osm_id,building,way) '
                         || manager.get_remote_select(dblink_name,remote_schema_name,base_building_table,base_building_attributes,base_building_clause);
    EXECUTE base_building_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'base_building_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- base_aeroway
    -----------------------------------------------------------------------------------------------
    -- select osm_id,aeroway,name,tags,way
    -- from public.planet_osm_polygon
    -- where aeroway is not null    
    -----------------------------------------------------------------------------------------------
    base_aeroway_attributes := '{osm_id,aeroway,name,tags,way}';
    base_aeroway_table := 'planet_osm_polygon';
    base_aeroway_clause := 'where aeroway is not null';
    base_aeroway_insert := 'INSERT INTO osm_data.base_aeroway (osm_id,aeroway,name,tags,way) ' 
                        || manager.get_remote_select(dblink_name,remote_schema_name,base_aeroway_table,base_aeroway_attributes,base_aeroway_clause);
    EXECUTE base_aeroway_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'base_aeroway_insert: % rows', myRowCount;
    
    -----------------------------------------------------------------------------------------------
    -- amen_restaurant
    -----------------------------------------------------------------------------------------------
    amen_restaurant_attributes := '{osm_id,addr:housenumber,amenity,name,tags,way}';
    amen_restaurant_table := 'planet_osm_point';
    amen_restaurant_clause := 'where amenity like ''''%restaurant%''''';
    amen_restaurant_insert := 'INSERT INTO osm_data.amen_restaurant (osm_id,"addr:housenumber",amenity,name,tags,way) ' 
                           || manager.get_remote_select(dblink_name,remote_schema_name,amen_restaurant_table,amen_restaurant_attributes,amen_restaurant_clause);
    EXECUTE amen_restaurant_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'amen_restaurant_insert: % rows', myRowCount;
    
    -----------------------------------------------------------------------------------------------
    -- amen_health
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",amenity,name,tags,way
    -- from public.planet_osm_point
    -- where amenity in ('hospital','veterinary','pharmacy','dentist','doctors','clinic');
    -----------------------------------------------------------------------------------------------
    amen_health_attributes := '{osm_id,addr:housenumber,amenity,name,tags,way}';
    amen_health_table := 'planet_osm_point';
    amen_health_clause := 'where amenity in (''''hospital'''',''''veterinary'''',''''pharmacy'''',''''dentist'''',''''doctors'''',''''clinic'''')';
    amen_health_insert := 'INSERT INTO osm_data.amen_health (osm_id,"addr:housenumber",amenity,name,tags,way) ' 
                       || manager.get_remote_select(dblink_name,remote_schema_name,amen_health_table,amen_health_attributes,amen_health_clause);
    EXECUTE amen_health_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'amen_health_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- amen_education
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",amenity,name,tags,way
    -- from public.planet_osm_point
    -- where amenity in ('college','library','school');
    -----------------------------------------------------------------------------------------------
    amen_education_attributes := '{osm_id,addr:housenumber,amenity,name,tags,way}';
    amen_education_table := 'planet_osm_point';
    amen_education_clause := 'where amenity in (''''college'''',''''library'''',''''school'''')';
    amen_education_insert := 'INSERT INTO osm_data.amen_education (osm_id,"addr:housenumber",amenity,name,tags,way) ' 
                       || manager.get_remote_select(dblink_name,remote_schema_name,amen_education_table,amen_education_attributes,amen_education_clause);
    EXECUTE amen_education_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'amen_education_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- addr_number
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",amenity,name,shop,tags,way
    -- from public.planet_osm_point
    -- where "addr:housenumber" is not null
    -----------------------------------------------------------------------------------------------
    addr_number_attributes := '{osm_id,addr:housenumber,amenity,shop,name,tags,way}';
    addr_number_table := 'planet_osm_point';
    addr_number_clause := 'where "addr:housenumber" is not null';
    addr_number_insert := 'INSERT INTO osm_data.addr_number (osm_id,"addr:housenumber",amenity,shop,name,tags,way) ' 
                       || manager.get_remote_select(dblink_name,remote_schema_name,addr_number_table,addr_number_attributes,addr_number_clause);
    EXECUTE addr_number_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'addr_number_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- shop_supermarket
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",shop,name,tags,way
    -- from public.planet_osm_point
    -- where shop = 'supermarket';
    -----------------------------------------------------------------------------------------------
    shop_supermarket_attributes := '{osm_id,addr:housenumber,shop,name,tags,way}';
    shop_supermarket_table := 'planet_osm_point';
    shop_supermarket_clause := 'where shop = ''''supermarket''''';
    shop_supermarket_insert := 'INSERT INTO osm_data.shop_supermarket (osm_id,"addr:housenumber",shop,name,tags,way) '
                            || manager.get_remote_select(dblink_name,remote_schema_name,shop_supermarket_table,shop_supermarket_attributes,shop_supermarket_clause);
    EXECUTE shop_supermarket_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'shop_supermarket_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- shop_cloth
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",shop,name,tags,way
    -- from public.planet_osm_point
    -- where shop = 'clothes';
    -----------------------------------------------------------------------------------------------
    shop_cloth_attributes := '{osm_id,addr:housenumber,shop,name,tags,way}';
    shop_cloth_table := 'planet_osm_point';
    shop_cloth_clause := 'where shop = ''''clothes''''';
    shop_cloth_insert := 'INSERT INTO osm_data.shop_cloth (osm_id,"addr:housenumber",shop,name,tags,way) '
                      || manager.get_remote_select(dblink_name,remote_schema_name,shop_cloth_table,shop_cloth_attributes,shop_cloth_clause);
    EXECUTE shop_cloth_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'shop_cloth_insert: % rows', myRowCount;

    -----------------------------------------------------------------------------------------------
    -- shop_car
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",shop,name,tags,way
    -- from public.planet_osm_point
    -- where shop like '%car%';
    -----------------------------------------------------------------------------------------------
    shop_car_attributes := '{osm_id,addr:housenumber,shop,name,tags,way}';
    shop_car_table := 'planet_osm_point';
    shop_car_clause := 'where shop like ''''%car%''''';
    shop_car_insert := 'INSERT INTO osm_data.shop_car (osm_id,"addr:housenumber",shop,name,tags,way) '
                      || manager.get_remote_select(dblink_name,remote_schema_name,shop_car_table,shop_car_attributes,shop_car_clause);
    EXECUTE shop_car_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'shop_car_insert: % rows', myRowCount;
                      
    -----------------------------------------------------------------------------------------------
    -- shop_computer
    -----------------------------------------------------------------------------------------------
    -- select osm_id,"addr:housenumber",shop,name,tags,way
    -- from public.planet_osm_point
    -- where shop = 'computer';
    -----------------------------------------------------------------------------------------------
    shop_computer_attributes := '{osm_id,addr:housenumber,shop,name,tags,way}';
    shop_computer_table := 'planet_osm_point';
    shop_computer_clause := 'where shop = ''''computer''''';
    shop_computer_insert := 'INSERT INTO osm_data.shop_computer (osm_id,"addr:housenumber",shop,name,tags,way) '
                      || manager.get_remote_select(dblink_name,remote_schema_name,shop_computer_table,shop_computer_attributes,shop_computer_clause);
    EXECUTE shop_computer_insert;
    GET DIAGNOSTICS myRowCount = ROW_COUNT;
    RAISE NOTICE 'shop_computer_insert: % rows', myRowCount;
    
    RETURN 'OK';
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;