/*
Sys 스키마에서 값의 단위를 변환하고, performance_schema의 설정 및 데이터를 조회하는 등의 다양한 기능을 가진 함수들을 제공한다.
이 같은 함수들은 주로 sys 스키마의 뷰와 프로시저에서 사용된다.
*/

extract_schema_from_file_name(in_path VARCHAR(512))
-- 인자로 주어진 데이터 파일 경로에서 데이터베이스명을 추출해서 출력한다.

extract_table_from_file_name(in_path VARCHAR(512))
-- 인자로 주어진 데이터 파일 경로에서 테이블명을 추출해서 출력한다.

format_bytes(in_bytes TEXT)
-- 인자로 주어진 값을 바이트 단위의 사람이 읽을 수 있는 형식으로 변환해서 보여준다. 
-- MySQL 8.0.16 버전부터는 빌트인 함수은 FORMAT_BYTES()가 추가됐으며, sys.format_bytes 함수는 deprecated 됨.

format_path(in_path VARCHAR(512))
/*
인자로 주어진 경로 값에서 다음 시스템 변수에 지정된 경로 값과 일치하는 부분이 있는지 순서대로 매칭한 후 매칭된 부분을 해당 시스템 변수명으로 치환한 경로 값을 반환한다.
	datadir
	tmpdir
	slave_load_tmpdir
	innodb_data_home_dir
	innodb_log_group_home_dir
	innodb_undo_directory
	basedir
*/

format_statement(in_statement LONGTEXT)
-- 인자로 주어진 SQL문을 sys 스키마의 statement_truncate_len 옵션에 설정된 길이로 줄인 후 그 결과를 반환한다. 
-- SQL 문이 해당 옵션보다 길이가 짧은 경우 잘림이 발생하지 않으며, 긴 경우에는 SQL 문 중간 부분이 잘려 줄임표(...)로 표시된다.

format_time(in_picoseconds TEXT)
-- 인자로 주어진 피코초(Picoseconds)를 사람이 쉽게 이해할 수 있는 시간 단위의 값으로 변환해서 보여준다.
-- MySQL 8.0.16 버전부터는 빌트인 함숭니 FORMAT_PICO_TIME()이 추가됐으며 sys.format_time 함수는 deprecated 됨.

list_add(in_list TEXT, in_add_value TEXT)
-- 인자로 쉼표(,)로 구분된 값 목록과 해당 목록에 추가할 새로운 값을 입력받으며, 목록에 새로운 값을 추가한 결과를 반환한다.

list_drop(in_list TEXT, in_drop_value TEXT)
-- 인자로 쉼표(,)로 구분된 값 목록과 해당 목록에 삭제할 새로운 값을 입력받으며, 목록에 삭제 대상 값을 제거한 결과를 반환한다.

ps_is_account_enabled(in_host VARCHAR(60), in_user VARCHAR(32))
-- 인자로 주어진 계정이 현재 performance_schema에서 모니터링이 활성화돼 있는지에 대한 결과를 반환한다.

ps_is_consumer_enabled(in_consumer VARCHAR(64))
-- 인자로 주어진 저장 레벨(Consumer)이 현재 performance_schema에서 활성화돼 있는지에 대한 결과를 반환한다.
-- 주어진저장 레벨의 상위 레벨들이 모두 활성화돼 있어야 해당 저장 레벨도 활성화된 걸로 간주한다.

ps_is_instrument_default_enabled(in_instrument VARCHAR(128))
-- 인자로 주어진 수집 이벤트가 performance_schema에서 기본적으로 수집되게 활성화돼 있는지에 대한 결과를 반환한다.

ps_is_instrument_default_timed(in_instrument VARCHAR(128))
-- 인자로 주어진 수집 이벤트가 performance_schema에서 기본적으로 시간 측적이 수행되도록 설정돼 있는지에 대한 결과를 반환한다.

ps_is_thread_instrumented(in_connection_id BIGINT UNSIGNED)
/*
인자로 주어진 커넥션 ID 값이 현재 performance_schema에서 모니터링이 활성화돼 있는지에 대한 결과를 반환한다.
커넥션 ID 값은 다음의 값들과 동일한 유형의 값임 :
	performance_schema.threads 테이블의 PROCESSLIST_ID 칼럼값
	information_schema.processlist 테이블의 ID 칼럼값
	SHOW [FULL] PROCESSLIST 출력에서 ID 칼럼값
*/

ps_thread_id(in_connection_id BIGINT UNSIGNED)
-- 인자로 주어진 커넥션 ID에 대해 performance_schema에서 해당 커넥션에 매핑되는 스레드 ID 값을 결과로 반환한다.

ps_thread_account(in_thread_id BIGINT UNSIGNED)
-- 인자로 주어진 performance_schema의 스레드 ID 값에 대해 해당 스레드와 연결된 DB 계정을 결과로 반환한다.

ps_thread_stack(in_thread_id BIGINT, in_verbose BOOLEAN)
-- 인자로 주어진 스레드 ID에 대해 performance_schema가 수집한 이벤트 데이터를 간략한 JSON 형식의 데이터로 반환한다.
-- 두 번째 인자는 이벤트가 발생한 지점의 소스코드 파일명과 줄 번호를 데이터에 같이 표시할 것인지를 결정. (TRUE / FALSE)

ps_thread_trx_info(in_thread_id BIGINT UNSIGNED)
-- 인자로 주어진 스레드 ID에 대해 performance_schema에서 수집한 트랜잭션 데이터를 JSON 형식의 데이터로 반환한다.
-- 결과 데이터는 sys 스키마의 ps_thread_trx_info.max_length 옵션에 설정된 길이를 초과할 수 없으며,
-- 초과화는 경우에는 다음과 같은 에러가 담긴 JSON 데이터가 출력
-- { "error": "Trx info truncated: Row 5 was cut by GROUP_CONCAT()" }

quote_identifier(in_identifier TEXT)
-- 인자로 주어진 문자열을 백틱(`, Backtick)으로 감싼 결과를 반환한다.

sys_get_config(in_variable_name VARCHAR(128), in_default_value VARCHAR(128))
-- sys 스키마의 sys_config 테이블에서 인자로 주어진 변수명과 일치하는 옵션의 설정값을 반환한다.
-- 일치하는 옵션이 해당 테이블에 존재하지 않는 경우 두 번째 인자로 주어진 값을 결과로 반환한다.

version_major()
-- MySQL 서버 버전에서 메이저 버전 값만 추출해서 결과로 반환한다.

version_minor()
-- MySQL 서버 버전에서 마이너 버전 값만 추출해서 결과로 반환한다.

version_patch()
-- MySQL 서버 버전에서 패치 버전 값만 추출해서 결과로 반환한다.