--클러스터에서 현재 실행 중인 쿼리를 확인 (쿼리문 일부만 확인)
select
       i.pid as "PID"
     , i.xid as "Transaction ID"
     , i.query as "Query ID"
     , u.usename as "User"
     , convert_timezone('Asia/Seoul', i.starttime) as "start time"
     , i.suspended as "is suspended"
     , 'select pg_terminate_backend(' || i.pid || ');' as "kill session cmd"
     , i.text as "query text"
     , i.insert_pristine
     , i.concurrency_scaling_status
  from stv_inflight i
  join svl_user_info u
    on i.userid = u.usesysid
 where i.pid <> pg_backend_pid()
 order by i.starttime
;

--클러스터에서 현재 실행 중인 쿼리를 확인 (쿼리문 전체 확인)
select 
       i.pid as "PID"
     , i.query as "Query ID"
     , u.usename as "User"
     , convert_timezone('Asia/Seoul', i.starttime) as "start time"
     , i.text as "query text"
  from svv_query_inflight i
  join svl_user_info u
    on i.userid = u.usesysid
 where i.pid <> pg_backend_pid()
 order by i.starttime, i.userid, i.query, i.pid, i.sequence
;

-- PID와 연결된 host IP 확인
select pid
     , dbname
     , username
     , remotehost
     , remoteport
     , convert_timezone('Asia/Seoul', recordtime) as "start time"
     , event
     , duration / 1000000 as "duration(s)"
     , application_name
     , os_version
     , driver_version
     , plugin_name
  from stl_connection_log
 where 1=1 
   and pid <> pg_backend_pid()
   and dbname = ''
--   and username = ''
 order by recordtime desc
;


-- 최근 실행된 쿼리 이력 확인 (현재 실행되고 있는 쿼리 포함)
select 
       status
     , user_name
     , convert_timezone('Asia/Seoul', starttime) as "start time"
     , duration
     , pid
     , query -- 최대 600자까지 조회
  from stv_recents r
 where 1=1
   and pid <> pg_backend_pid()
   and db_name = ''
--   and user_name = ''
--   and status='Running'  -- 현재 실행중인 쿼리 필터링
 order by status, starttime


-- 현재 실행중인 세션 조회
select * from stv_sessions;

-- Lock 조회
select * from pg_catalog.svv_transactions;