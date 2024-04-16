-- this script works best on redhat9
-- AIRPORTDB requires at least have 30GiB.

-- EMPLOYEES
-- download and install sample database: "employees"
https://dev.mysql.com/doc/employee/en/employees-installation.html
https://github.com/datacharmer/test_db
sudo dnf install unzip
unzip test_db-master.zip
cd test_db-master/
mysql -h localhost -P 3306 -u root -pmysql123 -t < employees.sql




-- AIRPORTDB
-- download sample database: "airportdb"
sudo dnf install wget
wget https://downloads.mysql.com/docs/airport-db.tar.gz
tar xvzf airport-db.tar.gz

-- mysqlsh javascript version
wget https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.3.0-1.el9.x86_64.rpm
sudo dnf install mysql-shell-8.3.0-1.el9.x86_64.rpm

-- enable "local_infile" global system variable
mysql -h localhost -P 3306 -u root -pmysql123
show variables like 'local_infile';
SET PERSIST local_infile = 1;

-- install sample database: "airportdb"
mysqlsh root@localhost
util.loadDump("airport-db", {threads: 16, deferTableIndexes: "all", ignoreVersion: true})
util.loadDump("airport-db", {threads: 16, deferTableIndexes: "all", ignoreVersion: true, resetProgress: true})
\sql
CALL sys.heatwave_load(JSON_ARRAY('airportdb'), NULL);


use airportdb;
select count(*) from airline;
select count(*) from airplane;
select count(*) from airplane_type;
select count(*) from airport;
select count(*) from airport_geo;
select count(*) from airport_reachable;
select count(*) from booking;
select count(*) from employee;
select count(*) from flight;
select count(*) from flight_log;
select count(*) from flightschedule;
select count(*) from passenger;
select count(*) from passengerdetails;
select count(*) from weatherdata;
-- drop database airportdb;



-- check database size
SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 