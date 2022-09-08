metrics
-- MySQL 서버의 전체적인 메트릭 정보 확인. 다음의 항목들 포함 :
	-- performance_schema.global_status 테이블의 전역 상태 변수
	-- information_schema.INNODB_METRICS 테이블의 InnODB 메트릭
	-- performance_schema 에서 수집한 메모리 사용량 정보를 바탕으로 계산한 MySQL 서버의 현재 할당된 메모리 양과 MySQL 서버에서 할당 및 해제한 메모리의 총량
	-- 현재 시각 정보(유닉스 타임스탬프 형식 및 사람이 읽을 수 있는 형태 두 가지로 표시)

processlist, x$processlist
-- 현재 실행 중인 스레드들에 대한 정보 확인
-- 실행 중인 포그라운드 및 백그라운드 스레드들이 모두 표시됨

ps_check_lost_instrumentation
-- performance_schema에서 최대로 수집할 수 있는 이벤트 수를 제한하는 시스템 변수에 설정된 값으로 인해 실제로 performance_schema에서 수집이 제외된 이벤트들이 존재하는지에 대한 정보 확인

schema_auto_increment_columns
-- AUTO_INCREMENT 칼럼이 존재하는 테이블들에 대해 해당 칼럼의 현재 및 최댓값, 값 사용률 (시퀀스가 사용된 정도) 등의 정보 확인

schema_index_statistics, x$schema_index_statistics
-- 테이블에 존재하는 각 인덱스의 통계 정보 확인

schema_object_overview
-- 데이터베이스별로 해당 데이터베이스에 존재하는 객체들의 유형(테이블, 프로시저, 트리거 등) 별 객체 수 정보 확인

schema_redundant_indexes
-- 인덱스 칼럼 구성이 동일한 테이블 내 다른 인덱스의 칼럼 구성과 중복되는 인덱스에 대한 정보 확인
-- 인덱스를 구성하는 칼럼들의 순서가 동일해야 중복된 인덱스루 간주
-- 칼럼 구성이 오나전히 동일해야 하는 것이 아니라 포함 관계인 경우도 해당

x$schema_flattened_keys
-- 사용자가 생성한 테이블들에 존재하는 인덱스들의 목록 확인
-- 인덱스 이름 및 유니크 속성, 구성 칼럼 등의 정보 확인



schema_table_statistics, x$schema_table_statistics
-- 각 테이블에 대해 데이터 작업 유형별(Fetched/Inserted/Updated/Deleted) 수행 횟수와 지연 시간, I/O 발생량 및 지연 시간 등을 포함하는 통계 정보 확인
-- I/O 관련된 정보들은 x$ps_schema_table_statistics_io 뷰에서 제공하는 데이터를 참조

x$ps_schema_table_statistics_io
-- 테이블 또는 파일별로 발생한 I/O에 대해 읽기 및 쓰기의 발생 횟수, 발생량, 처리 시간의 총 합에 대한 정보를 로우 형식으로 확인

schema_table_statistics_with_buffer, x$schema_table_statistics_with_buffer
-- schema_table_statistics 뷰에서 제공하는 정보와 더불어 각 테이블의 InnoDB 버퍼풀 사용에 대한 통계 정보를 함께 확인
-- 뷰 실행 시 information_schema.INNODB_BUFFER_PAGE 테이블 데이터를 조회하므로 서비스에서 사용 중인 MySQL 서버에서 해당 뷰를 조회할 때 주의 필요

schema_tables_with_full_table_scans, x$schema_tables_with_full_table_scans
-- 전체 테이블 스캔이 발생한 테이블들의 목록 확인

schema_unused_indexes
-- MySQL 서버가 구동 중인 기간 동안 테이블에서 사용되지 않은 인덱스들의 목록 확인

session, x$session
-- processlist 또는 x$processlist 뷰와 동일한 정보를 제공하나 유저 세션에 해당하는 스레드들의 정보만 제공한다는 점이 다름

session_ssl_status
-- 각 클라이언트 연결에 대해 SSL 버전 및 암호화 방식(Cipher), SSL 세션 재사용 횟수 정보를 확인

statement_analysis, x$statement_analysis
-- MySQL 서버에서 실행된 전체 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 쿼리 처리와 관련된 통계 정보 확인

statement_with_errors_or_warnings, x$statements_with_errors_or_warnings
-- 쿼리 실행 시 경고 또는 에러를 발생한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 경고 및 에러에 대한 통계 정보 확인

statement_with_full_table_scans, x$statements_with_full_table_scans
-- 전체 테이블 스캔을 수행한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 인덱스 미사용 횟수, 접근 및 반환도니 총 데이터 수 등을 포함하는 통계 정보 확인

statements_with_runtimes_in_95th_percentile, x$statements_with_runtimes_with_95th_percentile
-- 평균 실행 시간이 95 백분위수 이상에 해당하는 쿼리들(즉, 평균 실행 시간이 상위 5%에 속함)에 대해 실행 횟수와 실행 시간, 반환한 로우 수 등 쿼리 실행 내역과 관련된 통계 정보 확인

x$ps_digest_95th_percentile_by_avg_us
-- 실행된 쿼리들의 평균 실행 시간을 기준으로 95 백분위수에 해당하는 평균 실행 시간 값을 확인

x$ps_digest_avg_latency_distribution
-- 평균 실행 시간별 쿼리들의 분포도를 확인

statements_with_sorting, x$statements_with_sorting
-- 정렬 작업을 수행한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 정렬 작업과 관련된 통계 정보를 확인

statements_with_temp_tables, x$statements_with_temp_tables
-- 처리 과정 중에 임시 테이블이 사용된 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 임시 테이블과 관련된 통계 정보 확인


version
-- Sys 스키마 버전과 MySQL 서버 버전 정보 확인

wait_classes_global_by_avg_latency, x$wait_classes_global_by_avg_latency
-- Wait 이벤트별로 평균 지연 시간에 대한 통계 정보 및 총 발생 횟수 확인
-- Wait 이벤트명은 기존의 Wait 이벤트들을 상위 세 번쨰 분류 기준에서 그룹화한 값으로 표시

wait_classes_by_global_by_latency, x$wait_classes_by_global_by_latency
-- Wait 이벤트별로 총 지연 시간에 대한 토예 정보 및 총 발생 횟수 확인
-- Wait 이벤트명은 기존의 Wait 이벤트들을 상위 세 번째 분류 기준에서 그룹화한 기준으로 표시

wait_by_host_by_latency, x$wait_by_host_by_latency
-- 호스트별로 발생한 Wait 이벤트별 지연 시간 통계 정보 확인

wait_by_user_by_latency, x$wait_by_user_by_latency
-- 유저별로 발생한 Wait 이벤트별 지연 시간 통계 정보 확인

waits_global_by_latency, x$waits_global_by_latency
-- MySQL 서버에서 발생한 전체 Wait 이벤트별 지연 시간 통계 정보 확인