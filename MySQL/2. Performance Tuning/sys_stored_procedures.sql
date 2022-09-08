/*
	사용자는 sys 스키마에서 제공하는 스토어드 프로시저들을 사용해 performance_schema 설정을 손쉽게 확인 및 변경
	MySQL 서버 상태와 현재 실행 중인 쿼리들에 대해 종합적으로 분석한 보고서 형태의 데이터도 확인 가능
*/


-- 두 번째 인자로 주어진 데이터베이스 명을 새로운 데이터베이스를 생성한 후, 첫 번째 인자로 주어진 데이터베이스에 존재하는 모든 테이블과 뷰를 참조하는 뷰를 해당 데이터베이스에 생성
call sys.create_synonym_db(in_db_name VARCHAR(64), in_synonym_db_name VARCHAR(64));

/* diagnostics(in_max_runtime INT UNSIGNED, in_interval INT UNSIGNED, in_ps_config ENUM)
현재 MySQL 서버 상태에 대한 정보를 보고서 형태로 출력.
최대 실행 시간(in_max_runtime)과 실행 간격(in_interval), 사용할 performance_schema 설정(in_ps_config)을 인자로 입력 받음
기본 최대 실행 시간은 60초, 인자에 값이 NULL로 주어지면 기본값으로 동작
실행 시간의 기본값은 30초, 인자에 값이 NULL로 주어지면 기본값으로 동작
사용할 performance_schema 설정으로는 다음과 같이 세 가지 값 입력 가능:
	current	: 현재 performance_schema의 수집 이벤트 및 저장 레벨을 그대로 사용
	medium	: 일부 수집 이벤트 및 저장 레벨을 추가로 활성화해서 사용
	full	: 모든 수집 이벤트 및 저장 레벨을 활성화해서 사용

current가 아닌 나머지 값들을 사용하는 경우, 프로시저에서는 sys.ps_setup_save 및 sys.ps_setup_reload_saved 프로시저를 호출해서
현재 performance_schema 설정을 백업한 후 프로시저 실행 완료 시점에 복구함.
medium이나 full로 사용할 때는 MySQL 서버 성능에 영향을 줄 수 있으므로 주의!

diagnostics() 프로시저 실행 시 sys 스키마 옵션들을 참조하는데, 다음은 프로시저에서 참조하는 옵션들과 각 옵션의 용도에 대한 간략한 설명이다.
diagnostics.allow_i_s_tables : diagnostics() 프로시저에서 information_schema의 TABLES 뷰를 조회해서 
	스토리지 엔진별 데이터 사이즈나 테이블 수 등의 정보를 실행 결과에 포함할 것인지에 대한 여부를 결정한다.
	ON 또는 OFF 값으로 설정 가능하며, 기본값은 OFF다.
diagnostics.include_raw : diagnostics() 프로시저에서는 sys 스키마의 metrics 뷰를 조회해서 얻은 데이터를 가공한 후 결과 데이터로 출력하는데,
	이 때 metrics 뷰에서 얻은 원본 데이터도 함꼐 출력할 것인지에 대한 여부를 결정한다.
	ON 또는 OFF 값으로 설정 가능하며, 기본값은 OFF다.
*/
call sys.diagnostics(in_max_runtime INT UNSIGNED, in_interval INT UNSIGNED, in_ps_config ENUM);

/*
인자로 주어진 쿼리문을 프리페어 스테이트먼트로 실행
프로시저에서는 프리페어 스테이트먼트를 생성한 후 바로 해제하므로 해당 구문을 재사용할 수는 없다.
	set @stmt = 'select * from information_schema.tables';
	select @stmt;
	call sys.execute_prepared_stmt(@stmt);
*/
call sys.execute_prepared_stmt(in_query LONGTEXT);

-- performance_schema 에서 모든 백그라운드 스레드에 대한 모니터링을 중단.
-- 실제로 모니터링 중단이 적용된 백그라운드 스레드 개수를 결과로 반환
call sys.ps_setup_disable_background_threads();

-- 인자로 주어진 문자열을 이름에 포함하고 있는 저장 레벨들을 performance_schema에서 모두 비활성화
-- 비활성화된 저장 레벨 수를 결과로 반환
call sys.ps_setup_disable_consumer(in_pattern VARCHAR(128));

-- 인자로 주어진 문자열을 이름에 포함하고 있는 수집 이벤트들을 performance_schema에서 모두 비활성화
-- 비활성화된 수집 이벤트 수를 결과로 반환
call sys.setup_disable_instrument(in_pattern VARCHAR(128));

/*
인자로 주어진 커넥션 ID에 매핑되는 스레드가 performance_schema에서 모니터링이 비활성화되도록 설정
커넥션 ID 값은 다음의 값들과 동일한 유형의 값임 :
	performance_schema.threads 테이블의 PROCESSLIST_ID 칼럼값
	information_schema.processlist 테이블의 ID 칼럼값
	SHOW [FULL] PROCESSLIST 출력에서 ID 칼럼값
*/
call sys.ps_setup_disable_thread(in_connection_id BIGINT);

-- performance_schema에서 모든 백그라운드 스레드에 대한 모니터링을 활성화
-- 활성화가 적용된 백그라운드 스레드 개수를 결과로 반환
call sys.setup_enable_background_threads();

-- 인자로 주어진 문자열을 이름에 포함하고 있는 저장 레벨들을 performance_schema에서 모두 활성화
-- 활성화된 저장 레벨 수를 결과로 반환
call sys.ps_setup_enable_consumer(in_pattern VARCHAR(128));

-- 인자로 주어진 문자열을 이름에 포함하고 있는 수집 이벤트들을 performance_schema에서 모두 활성화
-- 활성화된 수집 이벤트 수를 결과로 반환
call sys.setup_enable_instrument(in_pattern VARCHAR(128));

/*
인자로 주어진 커넥션 ID에 매핑되는 스레드가 performance_schema에서 모니터링이 활성화되도록 설정
커넥션 ID 값은 다음의 값들과 동일한 유형의 값임 :
	performance_schema.threads 테이블의 PROCESSLIST_ID 칼럼값
	information_schema.processlist 테이블의 ID 칼럼값
	SHOW [FULL] PROCESSLIST 출력에서 ID 칼럼값
*/
call sys.ps_setup_enable_thread(in_connection_id BIGINT);

-- performance_schema 설정을 기본값으로 초기화
-- 인자로 "TRUE" 값이 지정되면 프로시저에서 설정을 초기화할 때 사용된 SQL 문 등의 추가 정보가 출력됨
call sys.ps_setup_reset_to_default(in_verbose BOOLEAN);

/*
현재 performance_schema 설정을 임시 테이블을 생성해 백업.
다음 테이블의 데이터가 백업되며, 백업 시 다른 세션에서 동일하게 백업이 수행되는 것을 방지하고자 GET_LOCK() 함수를 통해 "sys.ps_setup_save" 문자열에 대한 잠금 생성.

	performance_schema.setup_actors
	performance_schema.setup_consumers
	performance_schema.setup_instruments
	performance_schema.threads
	
해당 문자열에 대한 잠금이 이미 생성돼 있는 경우 인자로 주어진 타임아웃 시간(초 단위)만큼 대기하며 타임아웃 시간을 초과하면 프로시저 실행은 실패.
정상적으로 생성된 잠금은 동일한 세션에서 ps_setup_reload_saved() 프로시저가 실행되거나 세션이 종료될 떄 임시 테이블과 함께 사라진다.
*/
call sys.ps_setup_save(in_timeout INT);

-- ps_setup_saved() 프로시저를 통해 백업된 performance_schema 설정을 현재 performance_schema에 적용
call sys.ps_setup_reload_saved();

-- 현재 performance_schema에서 비활성화돼 있는 모든 설정 확인
-- 사용자는 인자로 비활성화된 수집 이벤트들과 스레드들을 결과에 포함할 것인지를 설정해 프로시저를 실행할 수 있다.
call sys.ps_setup_show_disabled(in_show_instruments BOOLEAN, in_show_threads BOOLEAN);

-- 현재 performance_schema에서 비활성화돼 있는 저장 레벨 목록 확인
call sys.ps_setup_show_disabled_consumers();

-- 현재 performance_schema에서 비활성화돼 있는 수집 이벤트 목록 확인
call sys.ps_setup_show_disabled_instruments();

-- 현재 performance_schema에서 활성화돼 있는 모든 설정 확인
-- 사용자는 인자로 활성화된 수집 이벤트들과 스레드들을 결과에 포함할 것인지를 설정해 프로시저를 실행할 수 있다.
call sys.ps_setup_show_enabled(in_show_instruments BOOLEAN, in_show_threads BOOLEAN);

-- 현재 performance_schema에서 활성화돼 있는 저장 레벨 목록 확인
call sys.ps_setup_show_enabled_consumers();

-- 현재 performance_schema에서 활성화돼 있는 수집 이벤트 목록 확인
call sys.ps_setup_show_enabled_instruments();

-- performance_schema의 events_statements_summary_by_digest 테이블에 수집된 구문들의 평균 지연 시간을 텍스트 히스토그램 그래프로 출력.
call sys.ps_statement_avg_latency_histogram();

/* ps_trace_statement_digest(in_digest VARCHAR(32), in_runtime INT, in_interval DECIMAL(2,2), in_start_fresh BOOLEAN, in_auto_enable BOOLEAN)
인자로 주어진 쿼리 다이제스트에 대해 performance_schema에서 수집된 정보의 통계 데이터를 출력.
다음은 프로시저 인자들에 대한 간략한 설명이다.
	in_digest		: performance_schema의 events_statements_summary_by_digest 테이블에서 통계 데이터를 얻고 싶은 쿼리 다이제스트 값을 입력한다.
	in_runtime		: 몇 초 동안 데이터를 수집하고 분석할 것인지를 프로시저 수행 시간을 입력한다.
	in_interval		: 통계 데이터 생성 시 사용할 performance_schema의 events_stages_history_long 및 events_statements_history_long 테이블 스냅샷 데이터 생성 간격을 입력한다.
	in_start_fresh	: 통계 데이터 작성을 위한 분석 작업 전에 performance_schema에서 events_stages_history_long 및 events_statements_history_long 테이블 초기화 여부. (TRUE / FALSE)
	in_auto_enable	: 프로시저 실행 시 필요로 하는 performance_schema의 저장 레벨과 수집 이벤트들을 자동으로 활성화할 것인지 여부. (TRUE / FALSE)
					  TRUE를 입력하면 현재 performance_schema 설정을 sys.ps_setup_save 프로시저를 사용해 백업한 뒤,
					  performance_schema에서 events_stages_history_long 및 events_statements_history long 저장 레벨과 그 상위 저장 레벨을 모두 활성화하며,
					  stage 및 statement 관련된 수집 이벤트들도 전부 활성화. 
					  이후 프로시저가 종료되는 시점에 ps_setup_reload_saved 프로시저를 사용해 performance_schema를 기존 설정으로 복구.
*/
call sys.ps_trace_statement_digest(in_digest VARCHAR(32), in_runtime INT, in_interval DECIMAL(2,2), in_start_fresh BOOLEAN, in_auto_enable BOOLEAN);

/* ps_trace_thread(in_thread_id INT, in_outfile VARCHAR(255), in_max_runtime DECIMAL(20,2), in_interval DECIMAL(20,2), in_start_fresh BOOLEAN, in_auto_setup BOOLEAN, in_debug BOOLEAN)
인자로 주어진 스레드와 관련된 eprformance_schema 의 모든 데이터를 ".dot" 형식의 그래프 파일로 덤프한다.
다음은 프로시저 인자들에 대한 간략한 설명이다.
	in_thread_id	: 덤프할 스레드 ID
	in_outfile		: 출력할 ".dot"파일의 파일명
	in_max_runtime	: 스레드 데이터를 수집할 최대 시간을 지정. 기본값은 60초, NULL을 입력하면 기본값으로 동작.
	in_interval		: 스레드 데이터 수집 간격을 지정. 기본값은 1초, NULL을 입력하면 기본값으로 동작.
	in_start_fresh	: 데이터 수집 전 작업과 관련된 performance_schema의 테이블을 초기화할 것인지를 결정. (TRUE / FALSE)
					  TRUE로 입력할 경우 다음의 테이블이 초기화
						performance_schema.events_transactions_history_long
						performance_schema.events_statements_history_long
						performance_schema.events_stages_history_long
						performance_schema.events_waits_history_long
	in_auto_setup	: 프로시저 실행 시 인자로 주어진 스레드를 제외한 다른 나머지 스레드들을 performance_schema 에서 모니터링을 비활성화하고,
					  performance_schema의 모든 수집 이벤트와 저장 레벨을 활성화할 것인지 여부를 결정. (TRUE / FALSE)
					  TRUE로 입력할 경우 기존 performance_schema 설정은 백업됐다가 프로시저 종료 시점에 다시 복구.
	in_debug		: 그래프에 소스코드 파일명과 줄 번호 정보를 포함할 것인지 여부. (TRUE / FALSE)	
*/
call sys.ps_trace_thread(in_thread_id INT, in_outfile VARCHAR(255), in_max_runtime DECIMAL(20,2), in_interval DECIMAL(20,2), in_start_fresh BOOLEAN, in_auto_setup BOOLEAN, in_debug BOOLEAN);

-- performance_schema의 모든 요약(Summary) 및 이력(History) 테이블의 데이터를 초기화.
-- 초기화한 테이블 수를 결과로 출력.
-- 인자로 TRUE값을 지정하면 초기화 시 사용한 쿼리도 결과에 함께 출력.
call sys.ps_truncate_all_tables(in_verbose BOOLEAN);

/* statement_performance_analyzer(in_action ENUM, in_table VARCHAR(129), in_views SET)
서버에서 실행 중인 쿼리들에 대한 분석 보고서를 출력.
다음은 프로시저 인자들에 대한 간략한 설명.
	in_action	: 프로시저에서 수행할 작업을 지정한다. 다음의 값들로 입력 가능하다.
		1) snapshot
			기본적으로 sys.tmp_digests라는 이름을 가지는 임시 테이블을 생성한 후
			해당 테이블에 performance_schema의 events_statements_summary_by_digest 테이블 데이터에 대한 현재 스냅샷을 저장한다.
			두번째 인자인 in_table에 특정 테이블이 지정된 경우 해당 테이블 데이터를 임시 테이블에 저장한다.
			in_table에 지정된 테이블은 events_statements_by_digest 테이블의 스키마와 일치해야 한다.
			그렇지 않으면 에러가 발생한다.
		2) overall
			in_table 인자에 지정된 테이블의 내용을 기반으로 in_views 인자에 주어진 뷰들의 포맷을 사용해 분석 데이터를 출력.
			기존에 생성된 스냅샷 데이터를 사용하려는 경우 in_table 인자에 NULL을 입력하면 된다.
			in_table 인자값이 NULL이고 기존 스냅샷 데이터가 존재하지 않으면 새로운 스냅샷을 생성한 후 결과를 출력한다.
			출력되는 각각의 뷰 데이터는 sys 스키마의 sys.statement_performance_analyzer.limit 옵션에 설정된 행 수만큼만 최대로 출력 가능하다.
		3) delta
			in_table 인자에 지정된 참조 테이블의 데이터와 기존 스냅샷 데이터 사이의 델타 데이터를 계산해서 sys.temp_digests_delta 임시 테이블에 저장한 후,
			in_views 인자에 지정된 뷰 형태로 델타 데이터를 출력한다.
			출력되는 각각의 뷰 데이터는 sys 스키마의 sys.statement_performance_analyzer.limit 옵션에 설정된 행 수만큼만 최대로 출력 가능하다.
		4) create_table
			추후 스냅샷 데이터 저장에 사용될 일반 테이블을 생성한다.
		5) create_tmp
			추후 스냅샷 데이터 저장에 사용될 임시 테이블을 생성한다.
		6) save
			in_table 인자에 지정된 테이블에 스냅샷 데이터를 저장한다.
			in_table에 지정된 테이블은 performance_schema의 events_statements_summary_by_digest 테이블과 스키마와 일치해야 한다.
			스냅샷 데이터가 기존에 존재하지 않는 경우에는 새로운 스냅샷 데이터를 생성해서 해당 테이블에 저장한다.
		7) cleanup
			스냅샷 및 델타 데이터를 저장하고 있는 임시 테이블은 sys.tmp_digests와 sys.tmp_digests_delta를 제거한다.
	in_table	: in_action 인자에 지정된 프로시저 동작과 관련해서 사용될 테이블을 지정. 백틱(backtick)을 사용하지 않고, 'db_name.tb_name' 혹은 'tb_name' 형태로 입력.
	in_views	: 결과 데이터 출력에 사용될 뷰를 지정. 인자에는 여러 값을 쉼표로 구분해서 입력할 수 있다. 다음의 값이 사용 가능하다. 기본적으로 설정되는 값에는 'custom'을 제외한 모든 값이 포함되며, 인자에 NULL 값이 주어지는 경우 기본값이 입력된다.
		1) with_runtimes_in_95th_percentile
			statements_with_runtimes_in_95th_percentile 뷰를 사용해서 데이터를 출력한다.
		2) analysis
			statement_analysis 뷰를 사용해서 데이터를 출력한다.
		3) with_errors_or_warnings
			statements_with_errors_or_warnings 뷰를 사용해서 데이터를 출력한다.
		4) with_full_table_scans
			statements_with_full_table_scans 뷰를 사용해서 데이터를 출력한다.
		5) with_sorting
			statements_with_sorting 뷰를 사용해서 데이터를 출력한다.
		6) with_temp_tables
			statements_with_temp_tables 뷰를 사용해서 데이터를 출력한다.
		7) custom
			사용자가 정의한 뷰 또는 쿼리를 사용해서 데이터를 출력.
			sys 스키마의 statement_performance_analyzer.view 옵션에 지정된 값을 사용하며, 사용자는 해당 옵션에 쿼리 또는 직접 생성한 뷰의 이름을 설정할 수 있다.
			설정된 쿼리 혹은 뷰는 performance_schema의 events_statements_summary_by_digest 테이블을 조회하는 형태여야 한다.
*/
call sys.statement_performance_analyzer(in_action ENUM, in_table VARCHAR(129), in_views SET);

/*
인자로 주어진 데이터베이스와 테이블명을 바탕으로 해당 테이블이 MySQL에 존재하는지 확인하고, 존재하는 경우 테이블 타입 값을 주어진 변수(@out_exists)에 저장.
	call sys.table_exists('STG_PORTAL', 'TABLES', @out_exists);
	select @out_exists;
*/
call sys.table_exists(in_db VARCHAR(64), in_table VARCHAR(64), @out_exists)