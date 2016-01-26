@echo off
echo 0-5 for the whole world
echo select manager.bbox2tiles(0,5,-85.0511,85.0511,-180.0,180.0,'C:/osm4dys/Website/idmap'); | "C:\osm4dys\PostgreSQL\9.3\bin\psql.exe" -d osm4dys -U postgres

echo TODO
pause
