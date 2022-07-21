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

-- DROP PROCEDURE IF EXISTS `ERPAPP`.`sp_del_cm_health_chk_log`;
-- DROP PROCEDURE IF EXISTS `ERPAPP`.`sp_del_cm_user_login`;

DELIMITER //
CREATE PROCEDURE `ERPAPP`.`sp_del_cm_health_chk_log` ()
BEGIN
	DELETE FROM ERPAPP.CM_HEALTH_CHK_LOG 
     WHERE date_format(date_add(date_format(NOW(), '%Y-%m-%d %H:%i:%s'), interval -7 day), '%Y%m%d') > CRT_DT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `ERPAPP`.`sp_del_cm_user_login`()
BEGIN
	DELETE FROM ERPAPP.CM_USER_LOGIN
	 WHERE date_format(date_add(date_format(NOW(), '%Y-%m-%d %H:%i:%s'), interval -7 day), '%Y%m%d') > CRT_DT;
END//
DELIMITER ;

SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME LIKE 'sp_del%';
