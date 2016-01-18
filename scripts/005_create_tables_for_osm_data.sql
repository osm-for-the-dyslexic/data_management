-- aproach: correctness over completeness

---------------------------------------------------------------------------------------------------
-- Boundaries
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.base_boundary;
CREATE TABLE osm_data.base_boundary (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,
    osm_id bigint,
    admin_level text,
    tags hstore,
    way geometry(Geometry,3857)
);
CREATE INDEX base_boundary_gist ON osm_data.base_boundary USING gist(way);
-- select name,osm_id,admin_level,tags,way 
-- from public.planet_osm_polygon 
-- where boundary = 'administrative';


---------------------------------------------------------------------------------------------------
-- Highways
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.base_highway;
CREATE TABLE osm_data.base_highway(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,
    osm_id bigint,
    highway text,
    surface text,
    bridge text,
    tunnel text,
    tags hstore,
    way geometry(LineString,3857)
);
CREATE INDEX base_highway_gist ON osm_data.base_highway USING gist(way);
-- select name, osm_id, highway, surface, bridge, tunnel, tags, way 
-- from public.planet_osm_roads
-- where highway is not null


---------------------------------------------------------------------------------------------------
-- Buildings
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.base_building;
CREATE TABLE osm_data.base_building(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    osm_id bigint,
    building text,
    way geometry(Geometry,3857)
);
CREATE INDEX base_building_gist ON osm_data.base_building USING gist(way);
-- select osm_id,building,way 
-- from public.planet_osm_polygon
-- where building is not null


---------------------------------------------------------------------------------------------------
-- Aeroways
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.base_aeroway;
CREATE TABLE osm_data.base_aeroway(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    aeroway text,
    tags hstore,
    way geometry(Geometry,3857)
);
CREATE INDEX base_aeroway_gist ON osm_data.base_aeroway USING gist(way);
-- select osm_id,aeroway,name,tags,way
-- from public.planet_osm_polygon
-- where aeroway is not null


---------------------------------------------------------------------------------------------------
-- Amenities: restaurant
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.amen_restaurant;
CREATE TABLE osm_data.amen_restaurant(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    amenity text,
    tags hstore,
    way geometry(Point,3857)  
);
CREATE INDEX amen_restaurant_gist ON osm_data.amen_restaurant USING gist(way);
-- select osm_id,"addr:housenumber",amenity,name,tags,way
-- from public.planet_osm_point
-- where amenity like '%restaurant%';

---------------------------------------------------------------------------------------------------
-- Amenities: health
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.amen_health;
CREATE TABLE osm_data.amen_health(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    amenity text,
    tags hstore,
    way geometry(Point,3857)  
);
CREATE INDEX amen_health_gist ON osm_data.amen_health USING gist(way);
-- select osm_id,"addr:housenumber",amenity,name,tags,way
-- from public.planet_osm_point
-- where amenity in ('hospital','veterinary','pharmacy','dentist','doctors','clinic');

---------------------------------------------------------------------------------------------------
-- Amenities: education
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.amen_education;
CREATE TABLE osm_data.amen_education(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    amenity text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX amen_education_gist ON osm_data.amen_education USING gist(way);
-- select osm_id,"addr:housenumber",amenity,name,tags,way
-- from public.planet_osm_point
-- where amenity in ('college','library','school');

---------------------------------------------------------------------------------------------------
-- Addresses
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.addr_number;
CREATE TABLE osm_data.addr_number(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    amenity text,
    shop text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX addr_number_gist ON osm_data.addr_number USING gist(way);
-- select osm_id,"addr:housenumber",amenity,name,shop,tags,way
-- from public.planet_osm_point
-- where "addr:housenumber" is not null

---------------------------------------------------------------------------------------------------
-- Shops: supermarket
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.shop_supermarket;
CREATE TABLE osm_data.shop_supermarket(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    shop text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX shop_supermarket_gist ON osm_data.shop_supermarket USING gist(way);
-- select osm_id,"addr:housenumber",shop,name,tags,way
-- from public.planet_osm_point
-- where shop = 'supermarket';

---------------------------------------------------------------------------------------------------
-- Shops: clothes
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.shop_cloth;
CREATE TABLE osm_data.shop_cloth(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    shop text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX shop_cloth_gist ON osm_data.shop_cloth USING gist(way);
-- select osm_id,"addr:housenumber",shop,name,tags,way
-- from public.planet_osm_point
-- where shop = 'clothes';

---------------------------------------------------------------------------------------------------
-- Shops: cars
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.shop_car;
CREATE TABLE osm_data.shop_car(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    shop text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX shop_car_gist ON osm_data.shop_car USING gist(way);
-- select osm_id,"addr:housenumber",shop,name,tags,way
-- from public.planet_osm_point
-- where shop like '%car%';

---------------------------------------------------------------------------------------------------
-- Shops: computer
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS osm_data.shop_computer;
CREATE TABLE osm_data.shop_computer(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text,    
    osm_id bigint,
    "addr:housenumber" text,
    shop text,
    tags hstore,
    way geometry(Point,3857)
);
CREATE INDEX shop_computer_gist ON osm_data.shop_computer USING gist(way);
-- select osm_id,"addr:housenumber",shop,name,tags,way
-- from public.planet_osm_point
-- where shop = 'computer';

---------------------------------------------------------------------------------------------------
-- Manager: labels for attributes
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS manager.labels;
CREATE TABLE manager.labels(
    table_name text,
    column_name text,
    label text,
    position integer,
    CONSTRAINT labels_pkey PRIMARY KEY (table_name,column_name)
);

---------------------------------------------------------------------------------------------------
-- Manager: Associate Zoom level to layer to identify
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS manager.id_layers;
CREATE TABLE manager.id_layers(
    zoom integer,
    table_name text,
    position integer,
    where_clause text,
    id_attribute_name text,
    geometry_name text,
    CONSTRAINT id_layers_pkey PRIMARY KEY (zoom,table_name,position)
);

