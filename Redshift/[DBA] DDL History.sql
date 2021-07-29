-- DDL 실행 이력 확인. DDL의 PID 확인
select 
       u.usename
     , d.pid
     , d.xid
     , convert_timezone('Asia/Seoul', d.starttime) as "start time"
     , convert_timezone('Asia/Seoul', d.endtime) as "end time"
     , d.text
     , d.sequence
  from stl_ddltext d
  join svl_user_info u
    on d.userid = u.usesysid 
 order by d.starttime desc, u.usename, d.pid, d.xid, d.sequence 
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
   and username = ''
   and pid = 2527
 order by recordtime desc
;
