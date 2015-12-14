DROP FUNCTION IF EXISTS manager.get_remote_select(text, text, text, text[], text);
CREATE OR REPLACE FUNCTION manager.get_remote_select(dblink_name text,remote_schema_name text,remote_table_name text, remote_attribute_names text[], where_clause text)
    RETURNS text AS
$BODY$
    
DECLARE
    information_schema_query text;
    information_schema_record record;
    remote_attribute_name text;
    remote_attribute_types text[] := '{}';
    i int;
    remote_query text;
    
BEGIN
    FOR i IN array_lower(remote_attribute_names,1) .. array_upper(remote_attribute_names,1)
    LOOP
        remote_attribute_types := array_append(remote_attribute_types, 'ERROR_COLUMN_NOT_FOUND');
    END LOOP;    

    --RAISE NOTICE 'remote_attribute_types: %' , remote_attribute_types ;
    
    information_schema_query := '';
    information_schema_query := information_schema_query || 'SELECT * FROM dblink(''';
    information_schema_query := information_schema_query || dblink_name;
    information_schema_query := information_schema_query || ''',''';
    information_schema_query := information_schema_query || 'select table_schema,table_name,column_name,ordinal_position,data_type,udt_name,character_maximum_length,numeric_precision,numeric_scale ';
    information_schema_query := information_schema_query || 'from information_schema.columns where table_schema = ''''';
    information_schema_query := information_schema_query || remote_schema_name;
    information_schema_query := information_schema_query || ''''' and table_name = ''''';
    information_schema_query := information_schema_query || remote_table_name;
    information_schema_query := information_schema_query || ''''' order by ordinal_position';    
    information_schema_query := information_schema_query || ''') AS t1 (table_schema text, table_name text, column_name text, ordinal_position int,data_type text,udt_name text,character_maximum_length int,numeric_precision int,numeric_scale int)';
    --RAISE NOTICE 'information_schema_query: %' , information_schema_query ;
    
    FOR information_schema_record IN EXECUTE information_schema_query 
    LOOP
        FOR i IN array_lower(remote_attribute_names,1) .. array_upper(remote_attribute_names,1)
        LOOP
            remote_attribute_name := remote_attribute_names[i];
            IF remote_attribute_name = information_schema_record.column_name THEN
                CASE information_schema_record.data_type
                    WHEN 'character varying','varchar' THEN
                        remote_attribute_types[i] := information_schema_record.data_type;
                        remote_attribute_types[i] := remote_attribute_types[i] || '(' || information_schema_record.character_maximum_length || ')';
                    WHEN 'timestamp without time zone','bigint','double precision' THEN
                        remote_attribute_types[i] :=  information_schema_record.data_type;
                    WHEN 'numeric' THEN
                        remote_attribute_types[i] := information_schema_record.data_type;
                        remote_attribute_types[i] := remote_attribute_types[i] || '(' || information_schema_record.numeric_precision || ',' || information_schema_record.numeric_scale || ')';
                    WHEN 'USER-DEFINED' THEN
                        IF information_schema_record.udt_name = 'geometry' OR information_schema_record.udt_name = 'hstore' THEN
                            remote_attribute_types[i] := information_schema_record.udt_name;
                        ELSE
                            remote_attribute_types[i] := 'text';
                        END IF;
                    ELSE
                        remote_attribute_types[i] := information_schema_record.data_type;
                    END CASE;
            END IF;
        END LOOP;
    END LOOP;

    -- RAISE NOTICE 'remote_attribute_types: %' , remote_attribute_types ;
    
    remote_query := '';
    remote_query := remote_query || 'SELECT * FROM dblink(''';
    remote_query := remote_query || dblink_name;
    remote_query := remote_query || ''',''';
    remote_query := remote_query || 'SELECT ';
    FOR i IN array_lower(remote_attribute_names,1) .. array_upper(remote_attribute_names,1)
    LOOP
        remote_query := remote_query || '"' || remote_attribute_names[i] || '"' || ',';
    END LOOP;
    remote_query := trim(trailing ',' from remote_query);
    remote_query := remote_query || ' FROM ' || remote_schema_name || '.' || remote_table_name;
    IF where_clause <> '' THEN
        remote_query := remote_query || ' ' || where_clause;
    END IF;
    remote_query := remote_query || ''') AS t1 (';
    FOR i IN array_lower(remote_attribute_names,1) .. array_upper(remote_attribute_names,1)
    LOOP
        remote_query := remote_query || '"' || remote_attribute_names[i] || '"' || ' ' || remote_attribute_types[i] || ',';
    END LOOP;
    remote_query := trim(trailing ',' from remote_query);
    remote_query := remote_query || ')';
    
    --RAISE NOTICE 'remote_query: %' , remote_query ;
    RETURN remote_query;
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
/*
--- unused generate ERRORS
DROP FUNCTION IF EXISTS manager.num2deg(integer, integer, integer);
CREATE OR REPLACE FUNCTION manager.num2deg(zValue integer, xValue integer, yValue integer)
    RETURNS double precision[2] AS
$BODY$
    
DECLARE
    n integer;
    lonDeg double precision;
    temp double precision;
    latRad double precision;
    latDeg double precision;
    retval double precision[2];

BEGIN
    RAISE NOTICE 'zValue:%, xValue:%, yValue:%',zValue,xValue,yValue;
    n := 2 ^ zValue;
    lonDeg := xValue / n * 360.0 - 180.0;
    temp := pi() * (1 - 2 * yValue / n);
    latRad := atan((exp(temp) - exp(-temp))/2);
    latDeg := latRad* (180.0 / pi());
    retval[0] := latDeg;
    retval[1] := lonDeg;
    RAISE NOTICE 'latDeg:% (Y), lonDeg:% (X)',latDeg,lonDeg;
    RETURN retval;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 1;
*/
---------------------------------------------------
--- TEST 
---------------------------------------------------
-- select manager.num2deg(0,0,0);
-- select manager.num2deg(0,1,1);

DROP FUNCTION IF EXISTS manager.lon2tile(DOUBLE PRECISION, integer);
CREATE OR REPLACE FUNCTION manager.lon2tile(lon DOUBLE PRECISION, zoom INTEGER)
    RETURNS INTEGER AS
$BODY$
BEGIN
    RETURN FLOOR( (lon + 180) / 360 * (1 << zoom) )::INTEGER;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 1;
 
 
DROP FUNCTION IF EXISTS manager.lat2tile(DOUBLE PRECISION, integer);
CREATE OR REPLACE FUNCTION manager.lat2tile(lat DOUBLE PRECISION, zoom INTEGER)
    RETURNS INTEGER AS
$BODY$
BEGIN
    RETURN FLOOR( (1.0 - LN(TAN(RADIANS(lat)) + 1.0 / COS(RADIANS(lat))) / PI()) / 2.0 * (1 << zoom) )::INTEGER;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 1;

DROP FUNCTION IF EXISTS manager.tile2lat(integer, integer);
CREATE OR REPLACE FUNCTION manager.tile2lat(y integer, zoom integer)
    RETURNS double precision AS
$BODY$
DECLARE
    n float;
    sinh float;
    E float = 2.7182818284;
    
BEGIN
    n = PI() - (2.0 * PI() * y) / POWER(2.0, zoom);
    sinh = (1 - POWER(E, -2*n)) / (2 * POWER(E, -n));
    return DEGREES(ATAN(sinh));
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 1;
 
DROP FUNCTION IF EXISTS manager.tile2lon(integer, integer);
CREATE OR REPLACE FUNCTION manager.tile2lon(x integer, zoom integer)
    RETURNS double precision AS
$BODY$
BEGIN
    RETURN x * 1.0 / (1 << zoom) * 360.0 - 180.0;
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 1;


DROP FUNCTION IF EXISTS manager.tile2envelope(integer, integer, integer);
CREATE OR REPLACE FUNCTION manager.tile2envelope(zValue integer, xValue integer, yValue integer)
    RETURNS geometry AS
$BODY$
-- now returns the bbox in epsg 900913
DECLARE
    lat1 double precision;
    lon1 double precision;
    lat2 double precision;
    lon2 double precision;    
BEGIN
    lat1 := manager.tile2lat(yValue,zValue);
    lon1 := manager.tile2lon(xValue,zValue);
    lat2 := manager.tile2lat(yValue+1,zValue);
    lon2 := manager.tile2lon(xValue+1,zValue);
    --latlon1 := manager.num2deg(zValue,xValue,yValue);
    --latlon2 := manager.num2deg(zValue,xValue+1,yValue+1);
    -- xmin        ymin        xmax        ymax
    -- latlon1[1], latlon2[0], latlon2[1], latlon1[0]
    RETURN ST_Transform(ST_MakeEnvelope(lon1, lat1, lon2, lat2, 4326) , 900913);
    --RETURN ST_MakeEnvelope(latlon1[1], latlon2[0], latlon2[1], latlon1[0], 4326);
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE COST 2;

---------------------------------------------------
--- TEST 
---------------------------------------------------
/*
select '0,0,0', st_asewkt(manager.tile2envelope(0,0,0))
union all
select '1,1,1',st_asewkt(manager.tile2envelope(1,1,1))
union all
select '6,28,16',st_asewkt(manager.tile2envelope(6,28,16))
union all
select '6,28,17',st_asewkt(manager.tile2envelope(6,28,17))
union all
select '6,29,16',st_asewkt(manager.tile2envelope(6,29,16))
union all
select '6,29,17',st_asewkt(manager.tile2envelope(6,29,17))
*/

DROP FUNCTION IF EXISTS manager.data4tile(text, text, text, text, integer, integer, integer);
CREATE OR REPLACE FUNCTION manager.data4tile(tableName text, additionalWhereClause text , uuidAttribute text, geoemtryAttribute text,zValue integer, xValue integer, yValue integer)
    RETURNS TABLE(id uuid,intersection geometry) AS
$BODY$
    
DECLARE
    select_data_query text;

BEGIN
    select_data_query := '';
    select_data_query := select_data_query || 'SELECT ' || uuidAttribute || ' AS id, ' /*|| geoemtryAttribute || ' AS original_geom, ' */;
    select_data_query := select_data_query || 'ST_Intersection(' || geoemtryAttribute || ',' || 'manager.tile2envelope('|| zValue ||','|| xValue || ',' || yValue || ')' || ')  AS intersection' ||  ' ' ;
    select_data_query := select_data_query || 'FROM ' || tableName || ' ';
    select_data_query := select_data_query || 'WHERE ST_Intersects('|| geoemtryAttribute || ',' || 'manager.tile2envelope('|| zValue ||','|| xValue || ',' || yValue || ')' || ')' ;

    IF additionalWhereClause <> '' THEN
        select_data_query := select_data_query || ' AND ' || additionalWhereClause;
    END IF;
    
    --select_data_query := select_data_query || 'WHERE ' || geoemtryAttribute || ' && ' || 'manager.tile2envelope('|| zValue ||','|| xValue || ',' || yValue || ')' || ' ';

    RETURN QUERY EXECUTE select_data_query;
END;
$BODY$
LANGUAGE plpgsql STABLE;

---------------------------------------------------
--- TEST 
---------------------------------------------------
-- select * FROM manager.data4tile('osm_data.base_boundary','','id','way',0,0,0);
-- select * FROM manager.data4tile('osm_data.base_boundary','','id','way',6,28,16);
-- select * FROM manager.data4tile('osm_data.base_building','','id','way',16,28792,17377);

--select * FROM manager.data4tile('osm_data.base_boundary','','id','way',6,28,16);
--select * FROM manager.data4tile('osm_data.base_building','','id','way',16,28792,17377);
--create table manager.data_6_28_16 as select * FROM manager.data4tile('osm_data.base_boundary','','id','way',6,28,16);
select * FROM manager.data4tile('osm_data.base_boundary','admin_level = ''6''','id','way',6,28,16);
-- create table manager.tile_6_28_16 as select * from manager.tile2envelope(6,28,16);
