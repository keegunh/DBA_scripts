
--각 계정, ROLE 권한 현황 파악
WITH CTE AS (
 	 SELECT
	  DB_NAME() AS DB_NAME
    , PR.NAME PCPL_NAME
	, S.NAME AS SCH_NAME
	, O.NAME AS OBJ_NAME
	, O.TYPE
	, O.TYPE_DESC
	, PE.STATE_DESC
	, PE.PERMISSION_NAME
    FROM SYS.DATABASE_PRINCIPALS AS PR  
    JOIN SYS.DATABASE_PERMISSIONS AS PE  
        ON PE.GRANTEE_PRINCIPAL_ID = PR.PRINCIPAL_ID  
    JOIN SYS.OBJECTS AS O  
        ON PE.MAJOR_ID = O.OBJECT_ID  
    JOIN SYS.SCHEMAS AS S  
        ON O.SCHEMA_ID = S.SCHEMA_ID
         )
SELECT T.*
     , CASE T.PRIV_STUFF WHEN 'INSERT' THEN 'C'
						 WHEN 'SELECT' THEN 'R'
						 WHEN 'UPDATE' THEN 'U'
						 WHEN 'DELETE' THEN 'D'
	                     WHEN 'EXECUTE' THEN 'X'
						 WHEN 'DELETE,INSERT,SELECT,UPDATE' THEN 'CRUD'
						 ELSE NULL
     END AS PRIV_SUMM
	 , GRANT_DDL =  'GRANT ' + T.PRIV_STUFF + ' ON ' + T.SCH_NAME + '.' + T.OBJ_NAME + ' TO ' + T.PCPL_NAME + ';'
	 , REVOKE_DDL =  'REVOKE ' + T.PRIV_STUFF + ' ON ' + T.SCH_NAME + '.' + T.OBJ_NAME + ' FROM ' + T.PCPL_NAME + ';'
  FROM (
	SELECT
           T0.DB_NAME
		 , T0.PCPL_NAME
		 , T0.SCH_NAME
		 , T0.OBJ_NAME
		 , T0.TYPE
		 , T0.TYPE_DESC
	     , STUFF((
	       SELECT ',' + T1.PERMISSION_NAME
	         FROM CTE T1
	        WHERE T1.PCPL_NAME = T0.PCPL_NAME AND T1.OBJ_NAME = T0.OBJ_NAME AND T1.TYPE = T0.TYPE AND T1.TYPE_DESC = T0.TYPE_DESC
	        ORDER BY T1.PERMISSION_NAME
	          FOR XML PATH('')), 1, LEN(','), '') AS PRIV_STUFF
	  FROM CTE T0
	 GROUP BY T0.DB_NAME, T0.PCPL_NAME, T0.SCH_NAME, T0.OBJ_NAME, T0.TYPE, T0.TYPE_DESC
	 ) T
WHERE 1=1
  AND T.TYPE <> 'S' -- SYSTEM TABLE 제외
-- AND T.PCPL_NAME IN (
-- )
-- and t.obj_name in (
-- )
ORDER BY T.PCPL_NAME, T.OBJ_NAME


--DB, 스키마 권한 점검
SELECT state_desc
    ,permission_name
    ,'ON'
    ,class_desc
    ,SCHEMA_NAME(major_id) AS [SCHEMA NAME]
    ,'TO'
    ,USER_NAME(grantee_principal_id) AS [USER NAME]
FROM sys.database_permissions AS PERM
JOIN sys.database_principals AS Prin
    ON PERM.major_ID = Prin.principal_id
       --AND class_desc = 'SCHEMA'
WHERE 1=1
    --AND grantee_principal_id = user_id('TestUser')
    --AND permission_name = 'SELECT'
	--AND MAJOR_ID IN (SCHEMA_ID(''), SCHEMA_ID(''))
ORDER BY class_desc, USER_NAME(grantee_principal_id), state_desc, SCHEMA_NAME(major_id), PERMISSION_NAME
GO


-- DB ROLE 별 멤버 확인
SELECT A.ROLE_PRINCIPAL_ID AS ROLE_ID
     , B.NAME AS ROLE_NAME
	 , A.member_principal_id AS MEMBER_ID
	 , C.NAME AS MEMBER_NAME 
  FROM SYS.DATABASE_ROLE_MEMBERS A WITH(NOLOCK)
 INNER JOIN SYS.DATABASE_PRINCIPALS B WITH(NOLOCK) ON A.ROLE_PRINCIPAL_ID = B.PRINCIPAL_ID -- ROLE
 INNER JOIN SYS.DATABASE_PRINCIPALS C WITH(NOLOCK) ON A.MEMBER_PRINCIPAL_ID = C.PRINCIPAL_ID  -- MEMBER
 WHERE B.NAME = ''
GO

-- DB ROLE 별 권한 확인
 WITH    perms_cte as
(
        select USER_NAME(p.grantee_principal_id) AS principal_name,
                dp.principal_id,
                dp.type_desc AS principal_type_desc,
                p.class_desc,
                OBJECT_NAME(p.major_id) AS object_name,
                p.permission_name,
                p.state_desc AS permission_state_desc
        from    sys.database_permissions p
        inner   JOIN sys.database_principals dp
        on     p.grantee_principal_id = dp.principal_id
)
--role members
SELECT rm.member_principal_name, rm.principal_type_desc, p.class_desc, 
    p.object_name, p.permission_name, p.permission_state_desc,rm.role_name
FROM    perms_cte p
right outer JOIN (
    select role_principal_id, dp.type_desc as principal_type_desc, 
   member_principal_id,user_name(member_principal_id) as member_principal_name,
   user_name(role_principal_id) as role_name--,*
    from    sys.database_role_members rm
    INNER   JOIN sys.database_principals dp
    ON     rm.member_principal_id = dp.principal_id
) rm
ON     rm.role_principal_id = p.principal_id
order by 1

-- 서버 ROLE 별 멤버 확인
SELECT sys.server_role_members.role_principal_id
     , role.name AS RoleName
     , sys.server_role_members.member_principal_id
     , member.name AS MemberName  
FROM sys.server_role_members  
JOIN sys.server_principals AS role  
    ON sys.server_role_members.role_principal_id = role.principal_id  
JOIN sys.server_principals AS member  
    ON sys.server_role_members.member_principal_id = member.principal_id;