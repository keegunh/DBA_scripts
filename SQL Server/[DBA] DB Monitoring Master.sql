DECLARE @SPCFC_SPID NUMERIC;
SET @SPCFC_SPID = 0; -- BLK_SPID 입력

--Active Session
SELECT DISTINCT
        name AS database_name,
        sys.dm_exec_sessions.session_id,
        host_name,
		sys.dm_exec_connections.client_net_address,
        login_time,
        login_name,
        reads,
        writes
FROM    sys.dm_exec_sessions
        LEFT OUTER JOIN sys.dm_tran_locks ON sys.dm_exec_sessions.session_id = sys.dm_tran_locks.request_session_id
        INNER JOIN sys.databases ON sys.dm_tran_locks.resource_database_id = sys.databases.database_id
		INNER JOIN sys.dm_exec_connections (NOLOCK) ON sys.dm_exec_sessions.session_id = sys.dm_exec_connections.session_id
WHERE resource_type <> 'DATABASE'
AND name in ('NBMDB','NBMOLDB','NBMREPDB', 'NBMDBSI', 'NBMOLDBSI')
ORDER BY name

-- Blocked Session
set transaction isolation level read uncommitted
 select  
       'kill ' +  cast(r.blocking_session_id  as varchar(100)) as kill_cmd
     , spid = s.session_id
     , blk_spid = r.blocking_session_id
     --, r.cpu_time
	 , s.host_name
     , c.client_net_address
     , login = rtrim(s.login_name)
     , dbname = db_name(r.database_id)
     , r.start_time
     --, [dur(ms)] = r.total_elapsed_time
     --, [dur(s)] = convert(dec(12,2),convert(float,getdate()-p.last_batch)*24*60*60) --초단위 표시
	 , [dur(s)] = cast(convert(dec(12,2),convert(float,getdate()-r.start_time)*24*60*60) as nvarchar) --초단위 표시
     , [dur(m)] = datediff(mi,r.start_time, getdate())  --초단위 표시 --분은 mi
     --, [d(h)] = datediff(hh,r.start_time, getdate())  --초단위 표시 --분은 mi
     , status = convert(varchar(10), r.status)
     --, sql_text = SUBSTRING(rtrim(s2.text),  r.statement_start_offset / 2, ( (CASE WHEN r.statement_end_offset = -1 THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) ELSE r.statement_end_offset END)  - r.statement_start_offset) / 2)
     , cmd = rtrim(r.command)
	 , sql_full_text = rtrim(s2.text) 
     , program = s.program_name
     , tx = r.open_transaction_count
     , s3.query_plan
     , r.last_wait_type
     , wait_time = r.wait_time
     , wait_resource = rtrim(r.wait_resource)
     , lreads = r.logical_reads 
     , preads = r.reads 
     , pwrites = r.writes 
	 , r.sql_handle
	 , r.plan_handle
 	 , r.query_hash
     , r.query_plan_hash
	 , [gathering date] = CONVERT(varchar, getdate(), 120) 
  from sys.dm_exec_sessions s (nolock)
 inner join sys.dm_exec_requests r (nolock)
    on s.session_id = r.session_id
 outer apply sys.dm_exec_sql_text(r.sql_handle) s2
 outer apply sys.dm_exec_query_plan(r.plan_handle) s3
 inner join sys.dm_exec_connections c (nolock)
    on s.session_id = c.session_id
 where s.is_user_process = 1
   and s.session_id<>@@SPID
   --and s2.text like '%UNIQUE_QUERY_STRING%'
   and db_name(r.database_id) in ('NBMDB','NBMOLDB','NBMREPDB', 'NBMDBSI', 'NBMOLDBSI')
 order by r.start_time

--Lock Lists
SELECT DISTINCT
        name AS database_name,
        sys.dm_exec_sessions.session_id,
        host_name,
		sys.dm_exec_connections.client_net_address,
        login_name,
        login_time,
        reads,
        writes        
FROM    sys.dm_exec_sessions (NOLOCK)
        LEFT OUTER JOIN sys.dm_tran_locks (NOLOCK) ON sys.dm_exec_sessions.session_id = sys.dm_tran_locks.request_session_id
        INNER JOIN sys.databases (NOLOCK)ON sys.dm_tran_locks.resource_database_id = sys.databases.database_id
		INNER JOIN sys.dm_exec_connections (NOLOCK) ON sys.dm_exec_sessions.session_id = sys.dm_exec_connections.session_id
WHERE   resource_type <> 'DATABASE'
AND request_mode LIKE '%X%'
AND name in ('NBMDB','NBMOLDB','NBMREPDB', 'NBMDBSI', 'NBMOLDBSI')
ORDER BY name 


-- LOCK OBJECT 조회
SELECT  L.request_session_id AS SPID, 
        DB_NAME(L.resource_database_id) AS DatabaseName,
        O.Name AS LockedObjectName, 
        P.object_id AS LockedObjectId, 
        L.resource_type AS LockedResource, 
        L.request_mode AS LockType,
        ST.text AS SqlStatementText,        
        ES.login_name AS LoginName,
        ES.host_name AS HostName,
        TST.is_user_transaction as IsUserTransaction,
        AT.name as TransactionName,
        CN.auth_scheme as AuthenticationMethod
FROM    sys.dm_tran_locks L
        JOIN sys.partitions P ON P.hobt_id = L.resource_associated_entity_id
        JOIN sys.objects O ON O.object_id = P.object_id
        JOIN sys.dm_exec_sessions ES ON ES.session_id = L.request_session_id
        JOIN sys.dm_tran_session_transactions TST ON ES.session_id = TST.session_id
        JOIN sys.dm_tran_active_transactions AT ON TST.transaction_id = AT.transaction_id
        JOIN sys.dm_exec_connections CN ON CN.session_id = ES.session_id
        CROSS APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) AS ST
WHERE   resource_database_id = db_id()
ORDER BY L.request_session_id





-- Check Specific Session
 select  
       spid = s.session_id
	 , s.host_name
     , c.client_net_address
     , login = rtrim(s.login_name)
  from sys.dm_exec_sessions s (nolock)
 inner join sys.dm_exec_connections c (nolock)
    on s.session_id = c.session_id
 where s.is_user_process = 1
   and s.session_id = @SPCFC_SPID

   	  
-- 현재 실행중인 쿼리
SELECT 
   sqltext.TEXT,
   req.session_id,
   req.status,
   req.command,
   req.cpu_time,
   req.total_elapsed_time
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext 


---- 접속중인 로그인 및 IP
--SELECT S.spid, S.loginame, S.login_time, S.last_batch, C.client_net_address
--FROM sys.sysprocesses S, sys.dm_exec_connections C
--WHERE S.spid = C.session_id
----and S.loginame like '%bi_user%'


---- LONGRUNQRYMONITOR: 실행중인 + 롱 런 쿼리 조회
--SELECT r.session_id,
--       st.TEXT AS batch_text,
--       qp.query_plan AS 'XML Plan',
--       r.start_time,
--       r.status,
--       r.total_elapsed_time
--FROM sys.dm_exec_requests AS r
--     CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
--     CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
--WHERE 1=1
--  AND DB_NAME(r.database_id) = 'NBMDB'
--  AND st.TEXT not like '-- LONGRUNQRYMONITOR%'
--ORDER BY cpu_time DESC;

-- 쿼리 실행 이력
--SELECT 
--t.[text], s.last_execution_time, *
--FROM sys.dm_exec_cached_plans AS p
--INNER JOIN sys.dm_exec_query_stats AS s
--   ON p.plan_handle = s.plan_handle
--CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
--WHERE t.[text] LIKE N'%NBMBP_PCTR_SEL%'
--ORDER BY s.last_execution_time DESC;


--RUNQRYMONITOR: 실행 중인 쿼리 플랜 확인
select text, 
SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2) + 1) AS statement_text,
qp.query_plan,
* from sys.dm_exec_requests qs
cross apply sys.dm_exec_sql_text(sql_handle) st
cross apply sys.dm_exec_query_plan(plan_handle) qp
where text not like '%--RUNQRYMONITOR%'