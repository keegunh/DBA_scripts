show create user erpconv;
ALTER USER 'erpconv'@'%' IDENTIFIED BY '22EPDLXJwjsghks^!' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'CNSwjsghks@' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'LGCwjsghks*!' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'DPSTHFwjsghks22##' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

SELECT ID
     , USER
     , HOST
     , DB
     , COMMAND
     , TIME AS TIME_SEC
     , TIME / 60 / 60 AS TIME_HOURSnn
     , STATE
     , CONCAT('KILL ', ID, ';') AS KILL_CMD
     , INFO
  FROM INFORMATION_SCHEMA.PROCESSLIST
 WHERE USER = 'erpconv' 
 ORDER BY TIME DESC
;