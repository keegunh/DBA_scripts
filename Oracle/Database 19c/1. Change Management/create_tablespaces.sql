CREATE TABLESPACE TS_AAAD001 DATAFILE '/data004/DBID/data/ts_aaad001_01.dbf' SIZE 100M EXTENT MANAGEMENT LOCAL;
CREATE TABLESPACE TS_AAAI001 DATAFILE '/data004/DBID/indx/ts_aaai001_01.dbf' SIZE 100M EXTENT MANAGEMENT LOCAL;
CREATE TABLESPACE TS_AAAL001 DATAFILE '/data004/DBID/lob/ts_aaal001_01.dbf'  SIZE 100M EXTENT MANAGEMENT LOCAL;
CREATE TABLESPACE TS_AAAD001_P01 DATAFILE '/data004/DBID/data/ts_aaad001_p01_01.dbf' SIZE 100M EXTENT MANAGEMENT LOCAL;
CREATE TABLESPACE TS_AAAI001_P01 DATAFILE '/data004/DBID/indx/ts_aaai001_p01_01.dbf' SIZE 100M EXTENT MANAGEMENT LOCAL;

-- OR
CREATE TABLESPACE TS_AAAD001 DATAFILE '/data004/DBID/data/ts_aaai001_p01_01.dbf' SIZE 100M AUTOEXTEND ON MAXSIZE 30G;
CREATE TABLESPACE TS_AAAI001 DATAFILE '/data004/DBID/indx/ts_aaai001_p01_01.dbf' SIZE 100M AUTOEXTEND ON MAXSIZE 30G;