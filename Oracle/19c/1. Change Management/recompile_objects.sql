SELECT OBJECT_TYPE
     , OWNER
     , OBJECT_NAME
     , STATUS
     , TO_CHAR(CREATED, 'YYYY/MM/DD HH24:MM:SS') CREATED
     , TO_CHAR(LAST_DDL_TIME, 'YYYY/MM/DD HH24:MM:SS') LAST_DDL_TIME
     , 'ALTER ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME || ' COMPILE;' AS COMPILE_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE IN ( 'FUNCTION'
                      , 'PACKAGE'
                      , 'PACKAGE_BODY'
                      , 'PROCEDURE'
                      , 'TRIGGER'
                      , 'VIEW' )
   AND STATUS = 'INVALID'
 ORDER BY OBJECT_TYPE, OWNER, OBJECT_NAME
;