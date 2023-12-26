SELECT A.OBJECT_TYPE
     , A.OWNER
     , A.OBJECT_NAME
     , A.STATUS
     , A.CREATED
     , A.LAST_DDL_TIME
     , B.REFERENCED_OWNER
     , B.REFERENCED_NAME
     , B.REFERENCED_TYPE
     , B.REFERENCED_LINK_NAME
--     , B.DEPENDENCY_TYPE
  FROM DBA_OBJECTS A
     , DBA_DEPENDENCIES B
 WHERE A.OWNER = B.OWNER (+)
   AND A.OBJECT_NAME = B.NAME (+)
   AND A.OWNER = ''
   AND A.OBJECT_TYPE IN ( 'FUNCTION'
                        , 'PACKAGE'
                        , 'PACKAGE_BODY'
                        , 'PROCEDURE'
                        , 'TRIGGER'
                        , 'VIEW' )
   AND B.REFERENCED_OWNER NOT IN ('SYS', 'PUBLIC')
 ORDER BY A.OBJECT_TYPE, A.OWNER, A.OBJECT_NAME 
;