/*
	쿼리가 MySQL 서버에서 처리될 때 처리 단계별로 시간이 어느 정도 소요됐는지 확인할 수 있다면 쿼리의 성능을 개선하는 데 많은 도움이 될 것이다.
	MySQL에서는 이를 위해 쿼리 프로파일링 기능을 제공하고 있으며, performance_schema를 통해 쿼리의 처리 단계별 소요 시간을 확인할 수 있다.
	performance_schema의 설정이 반드시 활성화돼 있어야 한다.
*/

-- 현재 performance_schema 설정을 저장
call sys.ps_setup_save(10);

-- 실행된 쿼리에 매핑되는 이벤트 ID 값을 확인
SELECT event_id
     , sql_text
	 , sys.format_time(timer_wait) AS 'duration'
  FROM performance_schema.events_statements_history_long
 WHERE sql_text like '%200725%';
 
 +----------+-----------------------------------------+----------+
 | EVENT_ID | SQL_TEXT                                | duration |
 +----------+-----------------------------------------+----------+
 |     4011 | SELECT * FROM DB1.tb1 WHERE id = 200725 | 253 us   |
 +----------+-----------------------------------------+----------+

 
-- 확인한 이벤트 ID 값을 바탕으로 performance_schema의 events_stages_history_long 테이브을 조회하면 쿼리 프로파일링 정보를 확인할 수 있다.
SELECT event_name as 'stage'
     , sys.format_time(timer_wait) AS 'duration'
  FROM performance_schema.events_stages_history_long
 WHERE nesting_event_id = 4011
 ORDER BY timer_start;

 +--------------------------------------------------+----------+
 | stage                                            | duration |
 +--------------------------------------------------+----------+
 | stage/sql/starting                               | 77 us    |
 | stage/sql/Executing hook on transaction begin.   | 3 us     |
 | stage/sql/starting                               | 8 us     |
 | stage/sql/checking permissions                   | 5 us     |
 | stage/sql/Opening tables                         | 33 us    |
 | stage/sql/init                                   | 5 us     |
 | stage/sql/System lock                            | 8 us     |
 | stage/sql/optimizing                             | 10 us    |
 | stage/sql/statistics                             | 10 us    |
 | stage/sql/preparing                              | 10 us    |
 | stage/sql/executing                              | 10 us    |
 | stage/sql/end                                    | 4 us     |
 | stage/sql/query end                              | 3 us     |
 | stage/sql/waiting for handler commit             | 8 us     |
 | stage/sql/closing tables                         | 7 us     |
 | stage/sql/freeing items                          | 14 us    |
 | stage/sql/cleaning up                            | 1 us     |
 +--------------------------------------------------+----------+ 


-- performance_schema를 이전 설정으로 원상복구
CALL sys.ps_setup_reload_saved();