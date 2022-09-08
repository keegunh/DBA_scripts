/*
MySQL에서 동작 중인 스레드들의 메모리 사용량 확인
MySQL 내부 백그라운드 스레드 및 클라이언트 연결 스레드들의 현재 메모리 사용량 출력
sys.memory_by_thread_by_current_bytes 뷰는 기본적으로 current_allocated 칼럼값을 기준으로 내림차순으로 정렬해서 결과 출력
*/
SELECT thread_id
     , user
	 , current_allocated
  FROM sys.memory_by_thread_by_current_bytes LIMIT 10;
  
-- 특정 스레드에 대해 구체적인 메모리 할당 내역을 확인
-- WHERE 절에서 thread_id 값은 SHOW PROCESSLIST 명령문의 결과에 표시되는 ID 칼럼값과는 다른 값.
-- 여기서 thread_id 는 performance_schema에서 각 스레드를 식별하기 위해 부여한 ID 값.
SELECT thread_id
     , event_name
	 , sys.format_bytes(current_number_of_bytes_used) AS 'current_allocated'
  FROM performance_schema.memory_summary_by_thread_by_event_name
 WHERE thread_id = 12345678
 ORDER BY current_number_of_bytes_used DESC
 LIMIT 10;

-- SHOW PROCESSLIST의 ID 값을 바탕을 performance_schema에서의 thread_id 값을 확인하려면 다음과 같은 방법을 사용.
-- SHOW PROCESSLIST의 ID 값이 1234 인 스레드의 performance_schema thread_id 값 확인.
-- 방법1) performance_schema.threads 테이블 조회
SELECT thread_id, processlist_id FROM performance_schema.threads WHERE processlist_id = 1234;

-- 방법2) sys 스키마의 ps_thread_id 함수 사용
SELECT sys.ps_thread_id(1234);