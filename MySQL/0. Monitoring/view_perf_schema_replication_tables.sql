/*
*	Replication 테이블에서는 "SHOW [REPLICA | SLAVE] STATUS" 명령문에서 제공하는 것보다 더 상세한 복제 관련 정보를 제공
*/

-- 소스 서버로의 복제 연결 설정 정보 확인
SELECT channel_name
     , host
     , port
     , user
     , network_interface
     , auto_position
     , ssl_allowed
     , ssl_ca_file
     , ssl_ca_path
     , ssl_certificate
     , ssl_cipher
     , ssl_key
     , ssl_verify_server_certificate
     , ssl_crl_file
     , ssl_crl_path
     , connection_retry_interval
     , connection_retry_count
     , heartbeat_interval
     , tls_version
     , public_key_path
     , get_public_key
     , network_namespace
     , compression_algorithm
     , zstd_compression_level
  FROM performance_schema.replication_connection_configuration;

-- 소스 서버에 대한 복제 연결의 현재 상태 정보 확인
SELECT channel_name
     , group_name
     , source_uuid
     , thread_id
     , service_state
     , count_received_heartbeats
     , last_heartbeat_timestamp
     , received_transaction_set
     , last_error_number
     , last_error_message
     , last_error_timestamp
     , last_queued_transaction
     , last_queued_transaction_original_commit_timestamp
     , last_queued_transaction_immediate_commit_timestamp
     , last_queued_transaction_start_queue_timestamp
     , last_queued_transaction_end_queue_timestamp
     , queueing_transaction
     , queueing_transaction_original_commit_timestamp
     , queueing_transaction_immediate_commit_timestamp
     , queueing_transaction_start_queue_timestamp
  FROM performance_schema.replication_connection_status

-- 레플리카 서버의 레플리케이션 어플라이어 스레드(SQL 스레드)에 설정된 정보 확인
SELECT channel_name
     , desired_delay
     , privilege_checks_user
  FROM performance_schema.replication_applier_configuration;

-- 레플리케이션 어플라이어 스레드의 상태 정보 확인
SELECT channel_name
     , service_state
     , remaining_delay
     , count_transactions_retries
  FROM performance_schema.replication_applier_status;

-- 레플리케이션 코디네이터 스레드(Replication Coodrinator Thread)의 상태 정보 확인.
-- 복제가 멀티 스레드 복제로 설정되지 않은 경우에는 테이블은 비어 있음.
SELECT channel_name
     , thread_id
     , service_state
     , last_error_number
     , last_error_message
     , last_error_timestamp
     , last_processed_transaction
     , last_processed_transaction_original_commit_timestamp
     , last_processed_transaction_immediate_commit_timestamp
     , last_processed_transaction_start_buffer_timestamp
     , last_processed_transaction_end_buffer_timestamp
     , processing_transaction
     , processing_transaction_original_commit_timestamp
     , processing_transaction_immediate_commit_timestamp
     , processing_transaction_start_buffer_timestamp
  FROM performance_schema.performance_schema.replication_applier_status_by_coordinator;

-- 레플리케이션 워커 스레드(Replication Worker Thread)의 상태 정보 확인
SELECT channel_name
     , worker_id
     , thread_id
     , service_state
     , last_error_number
     , last_error_message
     , last_error_timestamp
     , last_applied_transaction
     , last_applied_transaction_original_commit_timestamp
     , last_applied_transaction_immediate_commit_timestamp
     , last_applied_transaction_start_apply_timestamp
     , last_applied_transaction_end_apply_timestamp
     , applying_transaction
     , applying_transaction_original_commit_timestamp
     , applying_transaction_immediate_commit_timestamp
     , applying_transaction_start_apply_timestamp
     , last_applied_transaction_retries_count
     , last_applied_transaction_last_transient_error_number
     , last_applied_transaction_last_transient_error_message
     , last_applied_transaction_last_transient_error_timestamp
     , applying_transaction_retries_count
     , applying_transaction_last_transient_error_number
     , applying_transaction_last_transient_error_message
     , applying_transaction_last_transient_error_timestamp
  FROM performance_schema.replication_applier_status_by_worker;

-- 특정 복제 채널에 적용되는 전역 복제 필터에 대한 정보 확인
SELECT channel_name
     , filter_name
     , filter_rule
     , configured_by
     , active_since
     , counter
  FROM performance_schema.replication_applier_filters;

-- 모든 복제 채널에 적용되는 전역 복제 필터에 대한 정보 확인
SELECT filter_name
     , filter_rule
     , configured_by
     , active_since
  FROM performance_schema.replication_applier_global_filters;

-- 그룹 복제를 구성하는 멤버들에 대한 네트워크 및 상태 정보 확인
SELECT channel_name
     , member_id
     , member_host
     , member_port
     , member_state
     , member_role
     , member_version
  FROM replication_group_members;

-- 비동기 복제 연결 장애 조치 메커니즘에서 사용될 소스 서버 목록 확인
performance_schema.replication_asynchronous_connection_failover

-- 각 그룹 복제 멤버의 트랜잭션 처리 통계 정보 확인
performance_schema.replication_member_stats

-- 바이너리 로그 및 릴레이 로그에 저장되는 트랜잭션의 압축에 대한 통계 정보 확인. 
-- 이 테이블은 MySQL 서버에서 바이너리 로그가 활성화돼 있고, 
-- binlog_transaction_compression 시스템 변수가 ON으로 설정된 경우에만 데이터가 저장됨.
performance_schema.binary_log_transaction_compression_stats