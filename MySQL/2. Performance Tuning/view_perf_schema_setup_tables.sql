/*
*	Performance_schema 가 어떤 대상에 대해 모니터링하며 어떤 이벤트들에 대한 데이터를 수집하고 
*	또 수집한 데이터를 어느 정도 상세한 수준으로 저장하게 될 것인지 제어
*
*	Performance_schema는 Producer - Consumer 방식으로 구현되어 있음.
*	Producer : 데이터를 수집하는 부분; 모니터링 대상과 데이터 수집 대상 이벤트들을 설정 가능
*	Consumer : 데이터를 저장하는 부분; 얼마나 상세하게 저장할 것인지 설정 가능
*
*	총 5개의 설정 테이블 
*
*	--------------------------------------------------------------------
*	|                   수집 부분                  |        저장 부분       |
*   |-------------------------------------------|----------------------|
*   |     모니터링 대상 설정     |  수집 대상 이벤트 설정  |     저장 레벨 설정       |
*   |-----------------------|-------------------|----------------------|
*   |    setup_objects      |                   |                      |
*   |    setup_threads      | setup_instruments |     setup_consumers  |
*   |    setup_actors       |                   |                      |
*	--------------------------------------------------------------------
*
*	1. 저장 레벨 설정 (setup_consumers)
*	데이터 수집 및 저장에 있어서 가장 큰 영향을 미치는 설정
*	저장 레벨들은 아래와 같이 계층 구조로 되어 있고 하위 레벨로 갈수록 데이터를 상세하게 저장
*	특정 저장 레벨을 활성화하고 싶은 경우 해당 저장 레벨의 모든 상위 저장 레벨도 모두 활성화해야 함.
*
*	global_instrumentation
*	|---thread_instrumentation
*	|	|---events_waits_current
*	|	|	|---events_waits_history
*	|	|	|---events_waits_history_long
*	|	|---events_stages_current
*	|	|	|---events_stages_history
*	|	|	|---events_stages_history_long
*	|	|---events_statements_current
*	|	|	|---events_statements_history
*	|	|	|---events_statements_history_long
*	|	|---events_transactions_current
*	|	|	|---events_transactions_history
*	|	|	|---events_transactions_history_long
*	|---statements_digest
*
*	2. 수집 대상 이벤트 설정 (setup_instruments)
*	사용자는 setup_instruments 테이블에서 ENABLED와 TIMED 칼럼의 값만 수정 가능
*
*	event_type 설명
*		wait : I/O 작업 및 잠금, 스레드 동기화 등과 같이 시간이 소요되는 이벤트를 의미
*		stage : SQL 명령문의 처리 단계와 관련된 이벤트를 의미
*		statement : SQL 명령문 또는 stored program에서 실행되는 내부 명령들에 대한 이벤트를 의미
*		transaction : MySQL 서버에서 실행되는 트랜잭션들에 대한 이벤트를 의미
*		memory : MySQL 서버에서 사용 중인 메모리와 관련된 이벤트를 의미
*		idle : 유휴 상태에 놓여있는 소켓과 관련된 이벤트를 의미
*		error : MySQL 서버에서 발생하는 경고 및 에러와 관련된 이벤트를 의미
*
*	3. 모니터링 대상 설정 (setup_objects, setup_actors, setup_threads)
*	Performance_schema 는 setup_instruments 테이블에서 설정된 수집 대상 이벤트들의 데이터를 모두 수집하는 것은 아니며,
*	Performance_schema가 모니터링하는 대상들과의 관련 여부를 확인해서 관련이 있는 경우 모니터링 대상들에 설정된 내용을 고려해 이벤트 데이터를 수집함.
*
*	특이사항 : DB가 재기동되면 모든 performance_schema 설정은 초기화됨. 저장하고 싶으면 performance_schema_instrument 옵션을 사용할 것.
*/

-- 저장 레벨 설정 확인
SELECT name
     , enabled
  FROM performance_schema.setup_consumers;

-- 저장 레벨 활성화
UPDATE performance_schema.setup_consumers
   SET enabled = 'YES'
 WHERE name LIKE '%history%';


-- 수집 대상 이벤트 설정 확인
SELECT SUBSTRING_INDEX(name, '/', 1) AS event_type 
     , name				-- 계층형으로 구성된 이벤트 클래스명
     , enabled
     , timed
     , properties
     , volatility		-- 이벤트 클래스의 휘발성. 큰 값일수록 이벤트 클래스의 인스턴스 생성 주기가 짧음.
     , documentation
  FROM performance_schema.setup_instruments;

-- 수집 대상 이벤트 활성화
-- * memory/performance_schema 로 시작하는 이벤트 클래스들은 항상 활성화돼 있으며 비활성화 시킬 수 없음.
UPDATE performance_schema.setup_instruments
   SET enabled = 'YES', timed = 'YES'
 WHERE name = 'stage/innodb/alter table%';

-- 모니터링 대상 설정 확인 (setup_objects)
SELECT object_type
     , object_schema
	 , object_name
	 , enabled
	 , timed
  FROM performance_schema.setup_objects;

-- 모니터링 대상 활성화 (setup_objects)
UPDATE performance_schema.setup_objects
   SET enabled = 'YES', timed = 'YES'
 WHERE object_type = 'TABLE'
   AND object_schema = '%';

-- 모니터링 대상 설정 확인 (setup_threads)
SELECT name				-- 스레들 클래스명
     , enabled
	 , history			-- 과거 이벤트 데이터 보관 여부 (활성화할 경우 history, history_long 키워드가 포함된 저장 레벨도 반드시 활성화해야함)
	 , properties
	 , volatility
	 , documentation
  FROM performance_schema.setup_threads;

-- 모니터링 대상 활성화 (setup_threads)
UPDATE performance_schema.setup_threads
   SET enabled = 'YES', history = 'YES'
 WHERE name like '%innodb%';


-- 모니터링 대상 설정 확인 (setup_actors)
SELECT host
     , user
	 , role
	 , enabled
	 , history
  FROM performance_schema.setup_actors;

-- 모니터링 대상 활성화 (setup_actors)
UPDATE performance_schema.setup_actors
   SET enabled = 'YES', history = 'YES';