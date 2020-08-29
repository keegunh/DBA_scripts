--------------------------------------------------------------------------------------
-- Name	       : OT (Oracle Tutorial) Sample Database
-- Link	       : http://www.oracletutorial.com/oracle-sample-database/
-- Version     : 1.0
-- Last Updated: July-28-2017
-- Copyright   : Copyright ? 2017 by www.oracletutorial.com. All Rights Reserved.
-- Notice      : Use this sample database for the educational purpose only.
--               Credit the site oracletutorial.com explitly in your materials that
--               use this sample database.
--------------------------------------------------------------------------------------
--------------------------------------------------------------------
-- execute the following statements to create a user name OT and
-- grant priviledges
--------------------------------------------------------------------


-- create tablespaces
CREATE TABLESPACE TS_TEST_DAT
DATAFILE 'C:\Oracle_Home\app\rlrms\oradata\ORCL\ts_test_dat_01.dbf' SIZE 500M,
         'C:\Oracle_Home\app\rlrms\oradata\ORCL\ts_test_dat_02.dbf' SIZE 500M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE        
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE TS_TEST_IDX
DATAFILE 'C:\Oracle_Home\app\rlrms\oradata\ORCL\ts_test_idx_01.dbf' SIZE 500M,
         'C:\Oracle_Home\app\rlrms\oradata\ORCL\ts_test_idx_02.dbf' SIZE 500M
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
SEGMENT SPACE MANAGEMENT AUTO;




-- create new user
CREATE USER C##OT IDENTIFIED BY 1234 
DEFAULT TABLESPACE TS_TEST_DAT
TEMPORARY TABLESPACE TEMP;
--DROP USER C##OT;

SELECT * FROM DBA_USERS WHERE USERNAME = 'C##OT';

-- grant priviledges
GRANT CONNECT, RESOURCE, DBA TO C##OT;