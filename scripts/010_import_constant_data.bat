@echo off

echo loading constant_data from 4 shapes
pause
"C:\osm4dys\PostgreSQL\9.3\bin\shp2pgsql.exe" -W "latin1" -I -s 4326 C:\osm4dys\constant_data\ne_50m_admin_0_countries.shp constant_data.ne_50m_admin_0_countries | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
"C:\osm4dys\PostgreSQL\9.3\bin\shp2pgsql.exe" -W "latin1" -I -s 4326 C:\osm4dys\constant_data\ne_50m_populated_places.shp constant_data.ne_50m_populated_places | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
"C:\osm4dys\PostgreSQL\9.3\bin\shp2pgsql.exe" -W "latin1" -I -s 4326 C:\osm4dys\constant_data\ne_50m_urban_areas.shp constant_data.ne_50m_urban_areas | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
"C:\osm4dys\PostgreSQL\9.3\bin\shp2pgsql.exe" -W "latin1" -I -s 3857 C:\osm4dys\constant_data\simplified_land_polygons.shp constant_data.simplified_land_polygons | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo data from 4 shapes loaded

echo transform geometries into srid 3857
pause
echo ALTER TABLE constant_data.ne_50m_admin_0_countries ALTER COLUMN geom TYPE geometry(MultiPolygon,3857) USING ST_Transform(geom,3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_populated_places ALTER COLUMN geom TYPE geometry(Point,3857) USING ST_Transform(geom,3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_urban_areas ALTER COLUMN geom TYPE geometry(MultiPolygon,3857) USING ST_Transform(geom,3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo transformed geometries into srid 3857

echo alter table primary key
pause
echo ALTER TABLE constant_data.ne_50m_admin_0_countries DROP CONSTRAINT ne_50m_admin_0_countries_pkey; | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_populated_places DROP CONSTRAINT ne_50m_populated_places_pkey; | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_urban_areas DROP CONSTRAINT ne_50m_urban_areas_pkey; | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.simplified_land_polygons DROP CONSTRAINT simplified_land_polygons_pkey; | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_admin_0_countries ADD COLUMN id uuid NOT NULL DEFAULT uuid_generate_v4(); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_populated_places ADD COLUMN id uuid NOT NULL DEFAULT uuid_generate_v4(); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_urban_areas ADD COLUMN id uuid NOT NULL DEFAULT uuid_generate_v4(); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.simplified_land_polygons ADD COLUMN id uuid NOT NULL DEFAULT uuid_generate_v4(); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_admin_0_countries ADD CONSTRAINT ne_50m_admin_0_countries_pkey PRIMARY KEY (id); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_populated_places ADD CONSTRAINT ne_50m_populated_places_pkey PRIMARY KEY (id); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_urban_areas ADD CONSTRAINT ne_50m_urban_areas_pkey PRIMARY KEY (id); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.simplified_land_polygons ADD CONSTRAINT simplified_land_polygons_pkey PRIMARY KEY (id); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo altered table primary key
pause

echo centroid and buffer creation
pause
echo ALTER TABLE constant_data.ne_50m_admin_0_countries ADD COLUMN centroid geometry(Point,3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo UPDATE constant_data.ne_50m_admin_0_countries set centroid = ST_PointOnSurface(geom); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo ALTER TABLE constant_data.ne_50m_populated_places ADD COLUMN buffer geometry(Polygon,3857); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo UPDATE constant_data.ne_50m_populated_places set buffer = ST_Expand(geom,40000); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo centroid and buffer created

echo materialized view creation
pause
echo CREATE MATERIALIZED VIEW constant_data.ne_50m_admin_0_countries_union AS SELECT ST_Union(ST_Buffer(ST_MakeValid(geom),0.1)), region_wb FROM constant_data.ne_50m_admin_0_countries GROUP BY region_wb; | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres
echo materialized view created
pause

