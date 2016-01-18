-- x  0-1-2-3
-- x  4-5-6-7
-- x  8-9-10-11
-- x  12-13-14-15
-- x  16-17-18-19
-- x  20-21-22-23
-- x  24-25-26-27
-- x  28-29-30-31
-- -
-- x  32-33-34-35
-- x  36-37-38-39
-- x  40-41-42-43
-- x  44-45-46-47
-- -   
-- 4  [48-49-50-51]
-- x  52-53-54-55
-- x  56-57-58-59
-- x  60-61-62-63
-- -
-- y  [64-65]-66-67  (8-9-A-B) 0100 0101 0110 0111
-- x  68-69-70-71
-- x  72-73-74-75
-- x  76-77-78-79
-- -
-- x  80-81-82-83
-- x  84-85-86-87
-- x  88-89-90-91
-- x  92-93-94-95
-- x  96-97-98-99
-- x  100-101-102-103
-- x  104-105-106-107
-- x  108-109-110-111
-- x  112-113-114-115
-- x  116-117-118-119
-- x  120-121-122-123
-- x  124-125-126-127

-- b00r    control bit set to 1, 2 bit for feature count, and 5 data bit   
-- b00g    8 data bit
-- b00b    8 data bit
-- b01r    control bit set to 0, 7 data bit
-- b01g    8 data bit
-- b01b    8 data bit
-- b02r    control bit set to 0, 7 data bit
-- b02g    8 data bit
-- b02b    8 data bit
-- b03r    control bit set to 0, 7 data bit
-- b03g    8 data bit
-- b04b    8 data bit
-- first row has 90 data bit

-- b10r    control bit set to 0, 7 data bit
-- b10g    8 data bit
-- b10b    8 data bit
-- b11r    control bit set to 0, 7 data bit
-- b11g    8 data bit
-- b11b    8 data bit
-- b12r    control bit set to 0, 7 data bit
-- b12g    8 data bit
-- b12b    8 data bit
-- b13r    control bit set to 0, 7 data bit
-- b13g    8 data bit
-- b14b    8 data bit
-- second row has 23*4 = 92 data bit --> 182 total

-- b20r    control bit set to 0, 7 data bit
-- b20g    8 data bit
-- b20b    8 data bit
-- b21r    control bit set to 0, 7 data bit
-- b21g    8 data bit
-- b21b    8 data bit
-- b22r    control bit set to 0, 7 data bit
-- b22g    8 data bit
-- b22b    8 data bit
-- b23r    control bit set to 0, 7 data bit
-- b23g    8 data bit
-- b24b    8 data bit
-- third row has 23*4 = 92 data bit --> 274 total

-- b30r    control bit set to 0, 7 data bit
-- b30g    8 data bit
-- b30b    8 data bit
-- b31r    control bit set to 0, 7 data bit
-- b31g    8 data bit
-- b31b    8 data bit
-- b32r    control bit set to 0, 7 data bit
-- b32g    8 data bit
-- b32b    8 data bit
-- b33r    control bit set to 0, 7 data bit
-- b33g    8 data bit
-- b34b    8 data bit
-- forth row has 23*4 = 92 data bit --> 366 total, done

DROP FUNCTION IF EXISTS manager.uuids2raster4x4(uuid,uuid,uuid);
CREATE OR REPLACE FUNCTION manager.uuids2raster4x4(uuid1 uuid, uuid2 uuid, uuid3 uuid)
    RETURNS raster AS
$$
    import uuid
    import math
    import time
    
    uuid0 = str(uuid.UUID('00000000000000000000000000000000'))
    counter = '00'
    if uuid0 == str(uuid1):
        counter = '00'
    elif uuid0 == str(uuid2):
        counter = '01'
    elif uuid0 == str(uuid3):
        counter = '10'
    else:        
        counter = '11'
    #----------------------------------------------------------------------------------------------
    #-- binRepresentation
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    uuidString = str(uuid1).replace('-','') + str(uuid2).replace('-','') + str(uuid3).replace('-','')
    binRepresentation = ""
    for c in uuidString:
        binRepresentation = binRepresentation + str(bin(int(c,base=16))[2:].zfill(4))
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("binRepresentation in %s"%(elapsedtime))


    #----------------------------------------------------------------------------------------------
    #-- interestingBits
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    interestingBits = ""
    interestingBits = interestingBits + binRepresentation[0:47+1] + binRepresentation[52:63+1] + binRepresentation[66:127+1]
    interestingBits = interestingBits + binRepresentation[128+0:128+47+1] + binRepresentation[128+52:128+63+1] + binRepresentation[128+66:128+127+1]
    interestingBits = interestingBits + binRepresentation[256+0:256+47+1] + binRepresentation[256+52:256+63+1] + binRepresentation[256+66:256+127+1]
    #-- len(interestingBits) = 366, len(binRepresentation) = 384 
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("interestingBits in %s"%(elapsedtime))
    
    #----------------------------------------------------------------------------------------------
    #-- bitlist
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    i = 0
    j = 5
    bitlist = [int('1'+counter+interestingBits[i:j],2)]  #-- control bit set to 1, 2 bit for feature count, and 5 data bit
    for k in range(1,48):
        i=j
        if k%3 == 0 :
            j+=7
            bitlist.append(int('0'+interestingBits[i:j],2))            
        else:
            j+=8
            bitlist.append(int(interestingBits[i:j],2))            
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("bitlist in %s"%(elapsedtime))

    #----------------------------------------------------------------------------------------------
    #-- raster creation
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    retv00 = plpy.execute("select ST_AddBand(ST_AddBand(ST_AddBand(ST_MakeEmptyRaster(4,4,0,0,1),null,'8BUI'::text,0,null),null,'8BUI'::text,0,null),null,'8BUI'::text,0,null) as the_raster",1)
    theraster = retv00[0]["the_raster"]
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("raster creation in %s"%(elapsedtime))
    
    #----------------------------------------------------------------------------------------------
    #-- raster population version 1
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    plan01 = plpy.prepare("SELECT ST_SetValue($1,$2,$3,$4,$5) as the_raster",["raster","integer","integer","integer","double precision"])
    for k in range(0,48):
        bandnum = int(k%3) + 1
        columnx = int(math.floor(k/3.0) %4 ) + 1
        rowy = int(math.floor(math.floor(k/3.0) / 4.0)) + 1 
        retv01 =  plpy.execute(plan01,[theraster,bandnum,columnx,rowy,bitlist[k]],1)
        theraster = retv01[0]["the_raster"]
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("raster population version 1 in %s"%(elapsedtime))
    
    #----------------------------------------------------------------------------------------------
    #-- raster population version 2
    #-- they are more or less the same - keep version 1
    #----------------------------------------------------------------------------------------------
    #-- starttime = time.time()
    #-- plan02 = plpy.prepare("SELECT ST_SetValues($1,$2,1,1,ARRAY[[$3,$4,$5,$6],[$7,$8,$9,$10],[$11,$12,$13,$14],[$15,$16,$17,$18]]::double precision[][],NULL::double precision) as the_raster",["raster","integer","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision","double precision"])
    #-- bitlist[0],bitlist[3],bitlist[6],bitlist[9],bitlist[12],bitlist[15],bitlist[18],bitlist[21],bitlist[24],bitlist[27],bitlist[30],bitlist[33],bitlist[36],bitlist[39],bitlist[42],bitlist[45]
    #-- bitlist[1],bitlist[4],bitlist[7],bitlist[10],bitlist[13],bitlist[16],bitlist[19],bitlist[22],bitlist[25],bitlist[28],bitlist[31],bitlist[34],bitlist[37],bitlist[40],bitlist[43],bitlist[46]
    #-- bitlist[2],bitlist[5],bitlist[8],bitlist[11],bitlist[14],bitlist[17],bitlist[20],bitlist[23],bitlist[26],bitlist[29],bitlist[32],bitlist[35],bitlist[38],bitlist[41],bitlist[44],bitlist[47]

    #-- retv02 =  plpy.execute(plan02,[theraster,1,bitlist[0],bitlist[3],bitlist[6],bitlist[9],bitlist[12],bitlist[15],bitlist[18],bitlist[21],bitlist[24],bitlist[27],bitlist[30],bitlist[33],bitlist[36],bitlist[39],bitlist[42],bitlist[45]],1)
    #-- theraster = retv02[0]["the_raster"]
    #-- retv02 =  plpy.execute(plan02,[theraster,2,bitlist[1],bitlist[4],bitlist[7],bitlist[10],bitlist[13],bitlist[16],bitlist[19],bitlist[22],bitlist[25],bitlist[28],bitlist[31],bitlist[34],bitlist[37],bitlist[40],bitlist[43],bitlist[46]],1)
    #-- theraster = retv02[0]["the_raster"]
    #-- retv02 =  plpy.execute(plan02,[theraster,3,bitlist[2],bitlist[5],bitlist[8],bitlist[11],bitlist[14],bitlist[17],bitlist[20],bitlist[23],bitlist[26],bitlist[29],bitlist[32],bitlist[35],bitlist[38],bitlist[41],bitlist[44],bitlist[47]],1)
    #-- theraster = retv02[0]["the_raster"]
    #-- elapsedtime = time.time() - starttime
    #-- plpy.notice("raster population version 2 in %s"%(elapsedtime))
        
    #-- --------------------------------------------
    #-- debug raster output to FS as png
    #-- --------------------------------------------
    #--plan99 = plpy.prepare("SELECT ST_AsPNG($1,ARRAY[1,2,3],1) as png",["raster"])
    #--with open("C:/temp/theraster.png", "wb") as f:
    #--    retv99 = plpy.execute(plan99,[theraster],1)
    #--    f.write(retv99[0]["png"])
    #--    
    #--with open("C:/temp/theraster.png.txt", "w") as f:
    #--    for k in range(0,48):
    #--        bandnum = int(k%3) + 1
    #--        columnx = int(math.floor(k/3.0) %4 ) + 1
    #--        rowy = int(math.floor(math.floor(k/3.0) / 4.0)) + 1
    #--        thevalue = int(bitlist[k])
    #--        f.write("" + str(columnx) + "," + str(rowy) + "," + str(bandnum) + ": " + str(thevalue) + "\n")
    
    return theraster
$$
LANGUAGE plpython3u IMMUTABLE COST 10;





/*
select uuids.* , manager.uuids2raster4x4(uuids.uuid1,uuids.uuid2,uuids.uuid3) as the_raster
from
(select uuid_generate_v4() as uuid1,
       uuid_generate_v4() as uuid2,
       uuid_generate_v4() as uuid3
) uuids
*/

DROP FUNCTION IF EXISTS manager.create_tile_on_file_system(text,integer,integer,integer);
CREATE OR REPLACE FUNCTION manager.create_tile_on_file_system(filesystemdir text, zvalue integer, xvalue integer, yvalue integer)
    RETURNS text AS
$$
    import base64
    import os
    import uuid
    import struct
    import sys
    import time
    
    starttime = time.time()
    
    filename = ""
    filename += filesystemdir + "/" + str(zvalue) + "/" + str(xvalue) + "/" + str(yvalue) + ".png"
    
    #----------------------------------------------------------------------------------------------
    #-- create an UUID matrix 64x64x3
    #----------------------------------------------------------------------------------------------
    uuid0 = uuid.UUID('00000000000000000000000000000000')
    #--ncols = 10
    #--nrows =  5
    #--ndepth = 3
    ncols = 64
    nrows = 64
    ndepth = 3
    #-- usage uuidMatrix[col][row][depth]
    uuidMatrix = [[[uuid0 for i in range(ndepth)] for j in range(nrows)] for k in range(ncols)]
    #--print uuidMatrix[0][0][2]
    #--print uuidMatrix[0][4][2]
    #--print uuidMatrix[9][4][2]
    
    #----------------------------------------------------------------------------------------------
    #-- create reference empty raster using the envelope
    #----------------------------------------------------------------------------------------------
    retv00 = plpy.execute("SELECT ST_AsRaster(manager.tile2envelope(%s,%s,%s),64,64,ARRAY['8BUI'],ARRAY[50],ARRAY[0]) as the_raster"%(zvalue,xvalue,yvalue),1)
    idrasterreference = retv00[0]["the_raster"]

    retvCC = plpy.execute("SELECT table_name,where_clause,id_attribute_name,geometry_name FROM manager.id_layers WHERE zoom = %s ORDER BY position"%(zvalue))
    for j in range(len(retvCC)):
        table_name = retvCC[j]['table_name']
        where_clause = retvCC[j]['where_clause']
        id_attribute_name = retvCC[j]['id_attribute_name']
        geometry_name = retvCC[j]['geometry_name']
        
    
        #-- plan01 = plpy.prepare("SELECT * FROM manager.data4tile('osm_data.base_boundary','admin_level = ''6''','id','way',%s,%s,%s)"%(zvalue,xvalue,yvalue));
        #-- plan01 = plpy.prepare("SELECT * FROM manager.data4tile('osm_data.base_boundary','','id','way',%s,%s,%s)"%(zvalue,xvalue,yvalue));
        #-- plan01 = plpy.prepare("SELECT * FROM manager.data4tile('osm_data.base_boundary','','id','way',%s,%s,%s)"%(zvalue,xvalue,yvalue));
        #-- plan01 = plpy.prepare("SELECT * FROM manager.data4tile('constant_data.ne_50m_admin_0_countries','','id','geom',%s,%s,%s)"%(zvalue,xvalue,yvalue));
        plan01 = plpy.prepare("SELECT * FROM manager.data4tile('%s','%s','%s','%s',%s,%s,%s)"%(table_name,where_clause,id_attribute_name,geometry_name,zvalue,xvalue,yvalue));

        plan02 = plpy.prepare("SELECT ST_AsRaster($1,$2,ARRAY['8BUI'],ARRAY[100],ARRAY[0]) as the_raster",["geometry","raster"])
        retv01 = plpy.execute(plan01,[])
        plpy.notice("tile %s/%s/%s table_name %s has %s features "%(zvalue,xvalue,yvalue,table_name,len(retv01))) 
        #-- next step is to make a loop for geometries
        for i in range(len(retv01)):
            #-- plpy.notice("geometries loop: %s element"%(i))
            intersection = retv01[i]["intersection"]
            the_uuid = retv01[i]["id"]
        
            retv02 = plpy.execute(plan02,[intersection,idrasterreference],1)
            newRaster = retv02[0]["the_raster"]

            plan03 = plpy.prepare("SELECT ST_MapAlgebra($1,1,$2,1,'[rast1.val]+[rast2.val]','8BUI','FIRST') as the_raster",["raster","raster"])
            retv03 = plpy.execute(plan03,[idrasterreference,newRaster],1)
            newRasterComposed = retv03[0]["the_raster"]
            
            plan04 = plpy.prepare("SELECT (rnum-1)/$1 as the_row, (rnum-1)%$1 as the_col FROM ( SELECT t1.element,row_number() OVER () as rnum FROM (SELECT unnest(ST_DumpValues($2,1)) as element) t1 ) t2 WHERE t2.element = 150", ["integer","raster"])
            retv04 = plpy.execute(plan04,[ncols,newRasterComposed])
            
            the_len = len(retv04)
            for k in range(the_len):
                the_row = retv04[k]["the_row"]
                the_col = retv04[k]["the_col"]
                if uuid0 == uuidMatrix[the_col][the_row][0]:
                    uuidMatrix[the_col][the_row][0] = the_uuid
                elif uuid0 == uuidMatrix[the_col][the_row][1]:
                    uuidMatrix[the_col][the_row][1] = the_uuid
                elif uuid0 == uuidMatrix[the_col][the_row][2]:
                    uuidMatrix[the_col][the_row][2] = the_uuid
                else:
                    pass
                    #-- the record will be lost

    #----------------------------------------------------------------------------------------------
    #-- write final raster to filesystem in png format
    #----------------------------------------------------------------------------------------------
    
    if not os.path.exists(os.path.dirname(filename)):
        os.makedirs(os.path.dirname(filename))

    plan90 = plpy.prepare("SELECT * FROM manager.uuids2raster4x4($1,$2,$3) as the_4x4_raster",["uuid","uuid","uuid"]);
    retv90 = plpy.execute(plan90,[uuid0,uuid0,uuid0],1)
    finalraster = retv90[0]["the_4x4_raster"]
    
    plan91 = plpy.prepare("SELECT ST_SetUpperLeft($1,$2,$3) as the_4x4_raster",["raster","double precision","double precision"]);
    
    plan92 = plpy.prepare("SELECT st_union(t1.the_raster) as the_union from (select unnest($1) as the_raster) t1 ",["raster[]"]);
    
    rasterlist = []
    cachedict = {}
    
    for i in range(nrows):
        for j in range(ncols):
            
            #-- optimezed since the call to uuids2raster4x4 is the most time consuming task
            #-- starttime = time.time()
            thekey = "" + str(uuidMatrix[j][i][0]) + "|" + str(uuidMatrix[j][i][1]) + "|" + str(uuidMatrix[j][i][2])
            if thekey in cachedict:
                the4x4raster = cachedict[thekey]
            else:
                retv90 = plpy.execute(plan90,[uuidMatrix[j][i][0],uuidMatrix[j][i][1],uuidMatrix[j][i][2]],1)
                the4x4raster = retv90[0]["the_4x4_raster"]
                cachedict[thekey] = the4x4raster
            #-- elapsedtime = time.time() - starttime
            #-- plpy.notice("1 - raster %s,%s in %s"%(i,j,elapsedtime))
            
            #-- starttime = time.time()
            retv91 = plpy.execute(plan91,[the4x4raster,j*4,-i*4],1)
            the4x4raster = retv91[0]["the_4x4_raster"]
            #-- elapsedtime = time.time() - starttime
            #-- plpy.notice("2 - raster %s,%s in %s"%(i,j,elapsedtime))

            #-- starttime = time.time()
            rasterlist.append(the4x4raster)
            #-- elapsedtime = time.time() - starttime
            #-- plpy.notice("3 - raster %s,%s in %s"%(i,j,elapsedtime))
            
    retv92 = plpy.execute(plan92,[rasterlist],1)
    finalraster = retv92[0]["the_union"]
    
    
    #-- with open(filename+".txt", "w") as f:
    #--     for i in range(nrows):
    #--         f.write("\n")
    #--         for j in range(ncols):
    #--             counter = 0
    #--             for k in range(ndepth):
    #--                 if uuid0 != uuidMatrix[j][i][k]:
    #--                     counter = counter + 1
    #--             if counter == 0:
    #--                 f.write("-")
    #--             else:
    #--                 f.write(str(counter))        
    
    plan99 = plpy.prepare("SELECT ST_AsPNG($1,ARRAY[1,2,3],1) as png",["raster"])

    with open(filename, "wb") as f:
        retv99 = plpy.execute(plan99,[finalraster],1)
        f.write(retv99[0]["png"])
                    
    elapsedtime = time.time() - starttime
    plpy.notice("tile %s/%s/%s in %s"%(zvalue,xvalue,yvalue,elapsedtime))                    
    return filename
$$
LANGUAGE plpython3u ;

-- select manager.create_tile_on_file_system('c:/temp',6,28,16);
-- select manager.create_tile_on_file_system('c:/temp',0,0,0);

-- select manager.create_tile_on_file_system('c:/temp/base/osm4dys_id',0,0,0);

----------------------------------------------
--  level  --   ntiles   --  expected time  --
----------------------------------------------
--       0 --          1 --          10 sec --
--       1 --          4 --          40 sec --
----------------------------------------------
--       2 --         16 --           3 min --
--       3 --         64 --          11 min --
--       4 --        256 --          41 min --
----------------------------------------------
--       5 --       1024 --           2 h   --
--       6 --       4096 --          11 h   --
----------------------------------------------
--       7 --      16384 --           2 gg  --
--       8 --      65536 --           8 gg  --
--       9 --     262144 --          30 gg  --
--      10 --    1048576 --         121 gg  --
--      11 --    4194304 --         485 gg  --
--      12 --   16777216 --       1.941 gg  --
--      13 --   67108864 --       7.767 gg  --
--      14 --  268435456 --      31.068 gg  --
----------------------------------------------


-- 67108864
-- 134 217 728

DROP FUNCTION IF EXISTS manager.bbox2tiles(integer, integer, double precision, double precision, double precision, double precision,text);
CREATE OR REPLACE FUNCTION manager.bbox2tiles(zmin integer, zmax integer, latmin double precision, latmax double precision, lonmin  double precision, lonmax double precision,filesystemdir text)
    --RETURNS TABLE(z integer,x integer,y integer) AS
    RETURNS text AS
$BODY$
DECLARE
    zcurrent integer;
    xcurrent integer;
    ycurent integer;
    retval text;
    
    xmin bigint;
    xmax bigint;
    ymin bigint;
    ymax bigint;
    temp integer;
    tilecounter bigint;

BEGIN
    tilecounter := 0;

    if zmax < zmin then
        temp := zmin;
        zmin := zmax;
        zmax := temp;
    end if;
    
    for zcurrent in zmin .. zmax
    loop
        xmin := manager.lon2tile(lonmin, zcurrent);
        xmax := manager.lon2tile(lonmax, zcurrent);
        if xmax < xmin then
            temp := xmin;
            xmin := xmax;
            xmax := temp;
        end if;
        if xmin < 0 then
            xmin := 0;
        end if;
        if xmax > power(2,zcurrent)-1 then
            xmax := power(2,zcurrent)-1;
        end if;
        
        ymin := manager.lat2tile(latmin, zcurrent);
        ymax := manager.lat2tile(latmax, zcurrent);
        if ymax < ymin then
            temp := ymin;
            ymin := ymax;
            ymax := temp;
        end if;
        if ymin < 0 then
            ymin := 0;
        end if;        
        if ymax > power(2,zcurrent)-1 then
            ymax := power(2,zcurrent)-1;
        end if;
        tilecounter := tilecounter + (xmax-xmin+1)*(ymax-ymin+1);
        RAISE NOTICE 'level %: x from % to %, y from % to %, total % tiles, time % (est)',zcurrent,xmin,xmax,ymin,ymax, (xmax-xmin+1)*(ymax-ymin+1),((xmax-xmin+1)*(ymax-ymin+1) * interval '0.4 second') ;
        if filesystemdir <> '' then
            for xcurrent in xmin .. xmax
            loop
                for ycurrent in ymin .. ymax
                loop
                    --RAISE NOTICE 'generating tile %/%/% in %', zcurrent,xcurrent,ycurrent,filesystemdir;
                    retval := manager.create_tile_on_file_system(filesystemdir,zcurrent,xcurrent,ycurrent);
                    --RAISE NOTICE 'done %', retval;
                end loop;
            end loop;
        end if;
        
    end loop;
    RAISE NOTICE 'total of % tiles in % (est)',tilecounter, (tilecounter* interval '0.4 second');
    
    RETURN 'ok';
END;
$BODY$
LANGUAGE plpgsql IMMUTABLE;


-- select manager.bbox2tiles(0,5,-85.0511,85.0511,-180.0,180.0,'c:/temp/base/osm4dys_id');
-- select manager.bbox2tiles(15,16,-85.0511,85.0511,-180.0,180.0,'');

-- select manager.bbox2tiles(0,2,-85.0511,85.0511,-180.0,180.0,'c:/temp/base/osm4dys_id');
/*

INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (0,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (1,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (2,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (3,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (4,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (5,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (6,'constant_data.ne_50m_admin_0_countries',10,'','id','geom');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (6,'constant_data.ne_50m_populated_places',20,'','id','buffer');
INSERT INTO manager.id_layers (zoom,table_name,position,where_clause,id_attribute_name,geometry_name) 
                        VALUES (6,'osm_data.base_highway',30,'','id','way');
*/
-- select manager.bbox2tiles( 6, 6, 62.7949348789, 67.3398608256, -11.6015625, -26.71875, 'c:/temp/base/osm4dys_id');  -- iceland
--- select manager.bbox2tiles( 6, 18, 62.7949348789, 67.3398608256, -11.6015625, -26.71875, ''); -- iceland demo