CREATE DATABASE osm4dys WITH ENCODING='UTF8' OWNER=postgres CONNECTION LIMIT=-1; 

CREATE EXTENSION dblink;
-- Query returned successfully with no result in 280 ms.
CREATE EXTENSION postgis;
-- Query returned successfully with no result in 3660 ms.

-- from here https://www.python.org/download/releases/3.2/
-- download Windows X86-64 MSI Installer (3.2)
-- installation (full) in C:\Python32
-- ---> setup was successful
-- reboot postgres
CREATE LANGUAGE plpython3u;
-- Query returned successfully with no result in 1621 ms.
-- in case of error go here http://stackoverflow.com/questions/14106388/postgres-and-python

CREATE EXTENSION hstore;
-- Query returned successfully with no result in 530 ms.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Query returned successfully with no result in 50 ms.

-- only for development
-- modify postgresql.conf enable
-- shared_preload_libraries = '$libdir/plugin_debugger.dll'
-- CREATE EXTENSION pldbgapi;