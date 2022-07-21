-- event scheduler 확인
SELECT event_schema
     , event_name
     , CONVERT_TZ(last_executed, 'UTC', '+09:00') AS last_executed
     , time_zone
     , event_type
     , execute_at
     , interval_value
     , interval_field
     , starts
     , ends
     , status
     , on_completion
     , created
     , last_altered
     , event_comment
     , event_definition
--        event_catalog
--      , definer
--      , event_body
--      , sql_mode
--      , originator
--      , character_set_client
--      , collation_connection
--      , database_collation
  FROM information_schema.events;