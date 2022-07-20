/*
*	Lock 테이블들에서는 MySQL에서 발생한 잠금과 관련된 정보를 제공한다.
*/

-- 현재 잠금이 점유됐거나 잠금이 요청된 상태에 있는 데이터 관련 락(레코드 락 및 갭 락)에 대한 정보 확인
SELECT engine
     , engine_lock_id
     , engine_transaction_id
     , thread_id
     , event_id
     , object_schema
     , object_name
     , partition_name
     , subpartition_name
     , index_name
     , object_instance_begin
     , lock_type
     , lock_mode
     , lock_status
     , lock_data
  FROM performance_schema.data_locks;

-- 이미 점유된 데이터 락과 이로 인해 잠금 요청이 차단된 데이터 락 간의 관계 정보 확인
SELECT engine
     , requesting_engine_lock_id
     , requesting_engine_transaction_id
     , requesting_thread_id
     , requesting_event_id
     , requesting_object_instance_begin
     , blocking_engine_lock_id
     , blocking_engine_transaction_id
     , blocking_thread_id
     , blocking_event_id
     , blocking_object_instance_begin
  FROM performance_schema.data_lock_waits;

-- 현재 잠금이 점유된 메타데이터 락들에 대한 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , column_name
     , object_instance_begin
     , lock_type
     , lock_duration
     , lock_status
     , source
     , owner_thread_id
     , owner_event_id
  FROM performance_schema.metadata_locks;

-- 현재 잠금이 점유된 테이블 락에 대한 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , object_instance_begin
     , owner_thread_id
     , owner_event_id
     , internal_lock
     , external_lock
  FROM performance_schema.table_handles;