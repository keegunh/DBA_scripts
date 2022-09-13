/*
	종종 MySQL 서버에서 세션의 트랜잭션이 정상적으로 종료되지 않고 오랫동안 남아있는 경우가 있다.
	이 경우 해당 트랜잭션에서 실행한 쿼리들로 인해 다른 세션에서 실행된 쿼리가 처리되지 못하고 대기할 수 있으며,
	다량으로 쌓인 언두 데이터로 인해 쿼리 성능이 저하되는 등의 문제가 발생할 수도 있다.
	
	따라서 이 같은 문제 상황이 발생하지 않도록 트랜잭션이 남아있는 원인을 파악하고 해결하는 것이 중요한데,
	원인 파악을 위한 가장 간단한 방법으로는 우선 트랜잭션에서 실행된 쿼리들을 확인하는 것이다.
	
	트랜잭션에서 실행된 쿼리 내역을 통해 애플리케이션 서버의 어느 로직에서 이 트랜잭션을 발생시킨 건지 짐작해볼 수 있기 때문이다.
	다음 쿼리를 사용해 종료되지 않고 아직 열린 채로 남아있는 트랜잭션에서 실행한 쿼리 내역을 확인할 수 있다.
*/

SELECT ps_t.processlist_id
     , ps_esh.thread_id
	 , CONCAT(ps_t.processlist_user, '@', ps_t.processlist_host) AS 'db_account'
	 , ps_esh.event_name
	 , ps_esh.sql_text
	 , sys.format_Time(ps_esh.timer_wait) AS 'duration'
	 , DATE_SUB(NOW(), INTERVAL (SELECT variable_value from performance_schema.global_status WHERE variable_name = 'UPTIME') - ps_esh.timer_start * 10e-13 second)  AS 'start_time'
	 , DATE_SUB(NOW(), INTERVAL (SELECT variable_value from performance_schema.global_status WHERE variable_name = 'UPTIME') - ps_esh.timer_end * 10e-13 second)  AS 'end_time'
  FROM performance_schema.threads ps_t
 INNER JOIN performance_schema.events_transactions_current ps_etc
    ON ps_etc.thread_id = ps_t.thread_id
 INNER JOIN performance_schema.events_statements_history ps_esh
    ON ps_esh.nesting_event_id = ps_etc.event_id
 WHERE ps_etc.state = 'ACTIVE'
   AND ps_esh.mysql_errno = 0
 ORDER BY ps_t.processlist_id, ps_esh.timer_start;
 



-- 현재 열려 있는 트랜잭션이 아닌 특정 세션에서 실행된 쿼리들의 전체 내역을 확인하고 싶은 경우에는 다음 쿼리를 사용.
-- 쿼리 내역을 살펴보고 싶은 세션의 PROCESSLIST ID 값을 먼저 확인한 후 쿼리의 WHERE 절에 입력.
SELECT ps_t.processlist_id
     , ps_esh.thread_id
	 , CONCAT(ps_t.processlist_user, '@', ps_t.processlist_host) AS 'db_account'
	 , ps_esh.event_name
	 , ps_esh.sql_text
	 , sys.format_Time(ps_esh.timer_wait) AS 'duration'
	 , DATE_SUB(NOW(), INTERVAL (SELECT variable_value from performance_schema.global_status WHERE variable_name = 'UPTIME') - ps_esh.timer_start * 10e-13 second)  AS 'start_time'
	 , DATE_SUB(NOW(), INTERVAL (SELECT variable_value from performance_schema.global_status WHERE variable_name = 'UPTIME') - ps_esh.timer_end * 10e-13 second)  AS 'end_time'
  FROM performance_schema.events_statements_history ps_esh
 INNER JOIN performance_schema.threads ps_t
    ON ps_t.thread_id = ps_esh.thread_id
 WHERE 1=1
   -- AND ps_t.processlist_id = 123
   -- AND ps_esh.sql_text LIKE ''
   -- AND ps_esh.sql_text NOT LIKE 'SELECT 1%'
   AND ps_esh.sql_text IS NOT NULL
   AND ps_esh.mysql_errno = 0
 ORDER BY ps_esh.timer_start;