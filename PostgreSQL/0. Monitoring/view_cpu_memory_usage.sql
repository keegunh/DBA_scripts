/*
Monitoring CPU and memory usage from Postgres
We'll create two database tables that will allow you to query CPU and memory usage from within the database connection. This way your applications can monitor the health of the servers without needing to worry about another connection or another protocol.

You can run these commands on the master database and they will propagate to all the slave databases as well.

First, load the file foreign data wrapper and create the foreign data server:
*/
CREATE EXTENSION file_fdw;
CREATE SERVER fileserver FOREIGN DATA WRAPPER file_fdw;

-- Then we'll create the table that loads CPU loadavg from the /proc/loadavg file:
CREATE FOREIGN TABLE loadavg 
(one text, five text, fifteen text, scheduled text, pid text) 
SERVER fileserver 
OPTIONS (filename '/proc/loadavg', format 'text', delimiter ' ');

-- Creating the table that will let you query memory info is similar:
CREATE FOREIGN TABLE meminfo 
(stat text, value text) 
SERVER fileserver 
OPTIONS (filename '/proc/meminfo', format 'csv', delimiter ':');

-- Now you can run SELECT queries to see the info!
SELECT * FROM loadavg;

-- you can also query
SELECT * FROM meminfo;