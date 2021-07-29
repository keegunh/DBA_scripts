--Ŭ�����Ϳ��� ���� ���� ���� ������ Ȯ�� (������ �Ϻθ� Ȯ��)
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

--Ŭ�����Ϳ��� ���� ���� ���� ������ Ȯ�� (������ ��ü Ȯ��)
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

-- PID�� ����� host IP Ȯ��
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


-- �ֱ� ����� ���� �̷� Ȯ�� (���� ����ǰ� �ִ� ���� ����)
select 
       status
     , user_name
     , convert_timezone('Asia/Seoul', starttime) as "start time"
     , duration
     , pid
     , query -- �ִ� 600�ڱ��� ��ȸ
  from stv_recents r
 where 1=1
   and pid <> pg_backend_pid()
   and db_name = ''
--   and user_name = ''
--   and status='Running'  -- ���� �������� ���� ���͸�
 order by status, starttime


-- ���� �������� ���� ��ȸ
select * from stv_sessions;

-- Lock ��ȸ
select * from pg_catalog.svv_transactions;