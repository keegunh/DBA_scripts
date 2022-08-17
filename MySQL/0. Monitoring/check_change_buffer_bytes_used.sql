-- InnoDB는 변경해야 할 인덱스 페이지가 버퍼 풀에 있으면 바로 업데이트를 수행하지만 
-- 그렇지 않고 디스크로부터 읽어와서 업데이트해야 한다면 이를 즉시 실행하지 않고 
-- 임시 공간에 저장해 두고 사용자에게 결과를 바로 반환 -> 이렇게 response 타임을 줄이도록 구조되어 있다.
-- 이 때 사용하는 메모리 공간이 CHANGE BUFFER
-- 유니크 인덱스는 중복 체크를 해야 하기 때문에 CHANGE BUFFER를 사용할 수 없다.
-- CHANGE BUFFER는 기본적으로 InnoDB 버퍼 풀로 설정된 메모리 공간의 25%까지 사용할 수 있다.
SELECT EVENT_NAME
     , CURRENT_NUMBER_OF_BYTES_USED
  FROM performance_schema.memory_summary_global_by_event_name
 WHERE EVENT_NAME = 'memory/innodb/ibuf0ibuf';