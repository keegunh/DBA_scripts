/*
*	Instance 테이블들은 performance 스키마가 데이터를 수집하는 대상인 실체화된 객체들, 즉 인스턴스들에 대한 정보를 제공.
*/

-- 현재 MySQL 서버에서 동작 중인 스레드들이 대기하는 조건(Condition) 인스턴스들의 목록을 확인할 수 있다.
-- 조건은 스레드 간 동기화 처리와 관련해 특정 이벤트가 발생했음을 알리기 위해 사용되는 것으로, 스레드들은 자신들이 기다리고 있는 조건이 참이 되면 작업을 재개한다.
SELECT name
     , object_instance_begin  
  FROM performance_schema.cond_instances
;

-- 현재 MySQL 서버가 열어서 사용 중인 파일들의 목록을 확인.
-- 사용하던 파일이 삭제되면 이 테이블에서도 데이터가 삭제된다.
SELECT file_name
     , event_name
	 , open_count
  FROM performance_schema.file_instances
;

-- 현재 MySQL 서버에서 사용 중인 뮤텍스 인스턴스들의 목록을 확인할 수 있다.
SELECT name
     , object_instance_begin
	 , locked_by_thread_id
  FROM performance_schema.mutex_instances
;

-- 현재 MySQL 서버에서 사용 중인 읽기 및 쓰기 잠금 인스턴스들의 목록을 확인할 수 있다.
SELECT name
     , object_instance_begin
	 , write_locked_by_thread_id
	 , read_locked_by_count
  FROM performance_schema.rwlock_instances
;

-- 현재 MySQL 서버가 클라이언트의 요청을 대기하고 있는 소켓(Socket) 인스턴스들의 목록을 확인할 수 있다.
SELECT event_name
     , object_instance_begin
     , thread_id
     , socket_id
     , ip
     , port
     , state
  FROM performance_schema.socket_instances
;