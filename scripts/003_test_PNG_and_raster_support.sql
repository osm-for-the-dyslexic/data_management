SET postgis.gdal_enabled_drivers = 'ENABLE_ALL';

SELECT encode(ST_AsPNG(ST_AsRaster(ST_Buffer(ST_Point(1,5),10),150, 150, '8BUI')),'base64');
-- iVBORw0KGgoAAAANSUhEUgAAAJYAAACWCAAAAAAZai4+AAAAAnRSTlMAAHaTzTgAAAI3SURBVHic...


