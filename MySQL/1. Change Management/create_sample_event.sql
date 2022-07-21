/*
*	DELIMITER // 적용 여부는 SQL문장을 개별적으로 실행해서 확인할 게 아니라 SQL문 전체를 한꺼번에 실행하면서 확인해야 한다.
*	예를 들어 
*	DELIMITER // 실행하고
*   SELECT * FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_NAME LIKE 'evnt_sp_del%'; 를 따로 수행하면 select 문이 오류가 발생해야 할 것 같은데 정상 수행된다.
*
*	하지만
*	DELIMITER // 와
*   SELECT * FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_NAME LIKE 'evnt_sp_del%'; 를 한 번에 수행하면 select 문이 오류가 발생한다.
*
*	DELIMITER // 실행하고
*   SELECT * FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_NAME LIKE 'evnt_sp_del%'// 를 한 번에 수행해야 select 문이 오류 없이 수행된다.
*
*	즉 DELIMITER // 는 서버에서 있는 reserved word 나 명령어가 아니라 클라이언트 단에서 서버로 SQL을 날리기 전 때 SQL명령어를 조작하는 명령어인 것 같다.
* 
*	따라서 DELIMITER 명령어는 항상 DELIMITER가 변경되는 다른 SQL문과 같이 수행되어야 한다.
*
*	특이사항 : DBeaver에서 DELIMITER가 안 먹어서 원인을 파악하느라 2시간 정도 낭비했다. 이 때는 JAVA driver 를 Force download / overwrite 해서 이슈를 해결했다.
*/

-- DROP EVENT IF EXISTS `ERPAPP`.`evnt_sp_del_cm_health_chk_log`;
-- DROP EVENT IF EXISTS `ERPAPP`.`evnt_sp_del_cm_user_login`;

DELIMITER //
CREATE EVENT `ERPAPP`.`evnt_sp_del_cm_health_chk_log`
ON SCHEDULE EVERY 1 DAY STARTS '2022-07-18 23:00:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	CALL ERPAPP.sp_del_cm_health_chk_log;
END//
DELIMITER ;

DELIMITER //
CREATE EVENT `ERPAPP`.`evnt_sp_del_cm_user_login`
ON SCHEDULE EVERY 1 DAY STARTS '2022-07-18 23:00:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	CALL ERPAPP.sp_del_cm_user_login;
END//
DELIMITER ;

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