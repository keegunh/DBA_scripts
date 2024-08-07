/*
	IMPORT 10분 전에 TRUNCATE TABLE SCHEDULE 함.
*/

DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_TABLES`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 02:50:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.TABLES;
	TRUNCATE TABLE STG_LGCNS.TABLES;
	TRUNCATE TABLE STG_LGC.TABLES;
	TRUNCATE TABLE STG_LGES.TABLES;

	TRUNCATE TABLE DEV_PORTAL.TABLES;
	TRUNCATE TABLE DEV_LGCNS.TABLES;
	TRUNCATE TABLE DEV_LGC.TABLES;
	TRUNCATE TABLE DEV_LGES.TABLES;
	
	TRUNCATE TABLE QA3_PORTAL.TABLES;
	TRUNCATE TABLE QA3_LGCNS.TABLES;
	TRUNCATE TABLE QA3_LGC.TABLES;
	TRUNCATE TABLE QA3_LGES.TABLES;
	
	TRUNCATE TABLE PRD_PORTAL.TABLES;
	TRUNCATE TABLE PRD_LGCNS.TABLES;
	TRUNCATE TABLE PRD_LGC.TABLES;
	TRUNCATE TABLE PRD_LGES.TABLES;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_COLUMNS`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 04:10:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.COLUMNS;
	TRUNCATE TABLE STG_LGCNS.COLUMNS;
	TRUNCATE TABLE STG_LGC.COLUMNS;
	TRUNCATE TABLE STG_LGES.COLUMNS;

	TRUNCATE TABLE DEV_PORTAL.COLUMNS;
	TRUNCATE TABLE DEV_LGCNS.COLUMNS;
	TRUNCATE TABLE DEV_LGC.COLUMNS;
	TRUNCATE TABLE DEV_LGES.COLUMNS;
	
	TRUNCATE TABLE QA3_PORTAL.COLUMNS;
	TRUNCATE TABLE QA3_LGCNS.COLUMNS;
	TRUNCATE TABLE QA3_LGC.COLUMNS;
	TRUNCATE TABLE QA3_LGES.COLUMNS;
	
	TRUNCATE TABLE PRD_PORTAL.COLUMNS;
	TRUNCATE TABLE PRD_LGCNS.COLUMNS;
	TRUNCATE TABLE PRD_LGC.COLUMNS;
	TRUNCATE TABLE PRD_LGES.COLUMNS;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_PARTITIONS`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 05:30:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.PARTITIONS;
	TRUNCATE TABLE STG_LGCNS.PARTITIONS;
	TRUNCATE TABLE STG_LGC.PARTITIONS;
	TRUNCATE TABLE STG_LGES.PARTITIONS;

	TRUNCATE TABLE DEV_PORTAL.PARTITIONS;
	TRUNCATE TABLE DEV_LGCNS.PARTITIONS;
	TRUNCATE TABLE DEV_LGC.PARTITIONS;
	TRUNCATE TABLE DEV_LGES.PARTITIONS;
	
	TRUNCATE TABLE QA3_PORTAL.PARTITIONS;
	TRUNCATE TABLE QA3_LGCNS.PARTITIONS;
	TRUNCATE TABLE QA3_LGC.PARTITIONS;
	TRUNCATE TABLE QA3_LGES.PARTITIONS;
	
	TRUNCATE TABLE PRD_PORTAL.PARTITIONS;
	TRUNCATE TABLE PRD_LGCNS.PARTITIONS;
	TRUNCATE TABLE PRD_LGC.PARTITIONS;
	TRUNCATE TABLE PRD_LGES.PARTITIONS;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_STATISTICS`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 06:50:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.STATISTICS;
	TRUNCATE TABLE STG_LGCNS.STATISTICS;
	TRUNCATE TABLE STG_LGC.STATISTICS;
	TRUNCATE TABLE STG_LGES.STATISTICS;

	TRUNCATE TABLE DEV_PORTAL.STATISTICS;
	TRUNCATE TABLE DEV_LGCNS.STATISTICS;
	TRUNCATE TABLE DEV_LGC.STATISTICS;
	TRUNCATE TABLE DEV_LGES.STATISTICS;
	
	TRUNCATE TABLE QA3_PORTAL.STATISTICS;
	TRUNCATE TABLE QA3_LGCNS.STATISTICS;
	TRUNCATE TABLE QA3_LGC.STATISTICS;
	TRUNCATE TABLE QA3_LGES.STATISTICS;
	
	TRUNCATE TABLE PRD_PORTAL.STATISTICS;
	TRUNCATE TABLE PRD_LGCNS.STATISTICS;
	TRUNCATE TABLE PRD_LGC.STATISTICS;
	TRUNCATE TABLE PRD_LGES.STATISTICS;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_ROUTINES`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 08:10:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.ROUTINES;
	TRUNCATE TABLE STG_LGCNS.ROUTINES;
	TRUNCATE TABLE STG_LGC.ROUTINES;
	TRUNCATE TABLE STG_LGES.ROUTINES;

	TRUNCATE TABLE DEV_PORTAL.ROUTINES;
	TRUNCATE TABLE DEV_LGCNS.ROUTINES;
	TRUNCATE TABLE DEV_LGC.ROUTINES;
	TRUNCATE TABLE DEV_LGES.ROUTINES;
	
	TRUNCATE TABLE QA3_PORTAL.ROUTINES;
	TRUNCATE TABLE QA3_LGCNS.ROUTINES;
	TRUNCATE TABLE QA3_LGC.ROUTINES;
	TRUNCATE TABLE QA3_LGES.ROUTINES;
	
	TRUNCATE TABLE PRD_PORTAL.ROUTINES;
	TRUNCATE TABLE PRD_LGCNS.ROUTINES;
	TRUNCATE TABLE PRD_LGC.ROUTINES;
	TRUNCATE TABLE PRD_LGES.ROUTINES;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_TRIGGERS`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 09:30:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.TRIGGERS;
	TRUNCATE TABLE STG_LGCNS.TRIGGERS;
	TRUNCATE TABLE STG_LGC.TRIGGERS;
	TRUNCATE TABLE STG_LGES.TRIGGERS;

	TRUNCATE TABLE DEV_PORTAL.TRIGGERS;
	TRUNCATE TABLE DEV_LGCNS.TRIGGERS;
	TRUNCATE TABLE DEV_LGC.TRIGGERS;
	TRUNCATE TABLE DEV_LGES.TRIGGERS;
	
	TRUNCATE TABLE QA3_PORTAL.TRIGGERS;
	TRUNCATE TABLE QA3_LGCNS.TRIGGERS;
	TRUNCATE TABLE QA3_LGC.TRIGGERS;
	TRUNCATE TABLE QA3_LGES.TRIGGERS;
	
	TRUNCATE TABLE PRD_PORTAL.TRIGGERS;
	TRUNCATE TABLE PRD_LGCNS.TRIGGERS;
	TRUNCATE TABLE PRD_LGC.TRIGGERS;
	TRUNCATE TABLE PRD_LGES.TRIGGERS;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_VIEWS`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 10:50:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.VIEWS;
	TRUNCATE TABLE STG_LGCNS.VIEWS;
	TRUNCATE TABLE STG_LGC.VIEWS;
	TRUNCATE TABLE STG_LGES.VIEWS;

	TRUNCATE TABLE DEV_PORTAL.VIEWS;
	TRUNCATE TABLE DEV_LGCNS.VIEWS;
	TRUNCATE TABLE DEV_LGC.VIEWS;
	TRUNCATE TABLE DEV_LGES.VIEWS;
	
	TRUNCATE TABLE QA3_PORTAL.VIEWS;
	TRUNCATE TABLE QA3_LGCNS.VIEWS;
	TRUNCATE TABLE QA3_LGC.VIEWS;
	TRUNCATE TABLE QA3_LGES.VIEWS;
	
	TRUNCATE TABLE PRD_PORTAL.VIEWS;
	TRUNCATE TABLE PRD_LGCNS.VIEWS;
	TRUNCATE TABLE PRD_LGC.VIEWS;
	TRUNCATE TABLE PRD_LGES.VIEWS;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_SCHEMATA`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 12:10:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.SCHEMATA;
	TRUNCATE TABLE STG_LGCNS.SCHEMATA;
	TRUNCATE TABLE STG_LGC.SCHEMATA;
	TRUNCATE TABLE STG_LGES.SCHEMATA;

	TRUNCATE TABLE DEV_PORTAL.SCHEMATA;
	TRUNCATE TABLE DEV_LGCNS.SCHEMATA;
	TRUNCATE TABLE DEV_LGC.SCHEMATA;
	TRUNCATE TABLE DEV_LGES.SCHEMATA;
	
	TRUNCATE TABLE QA3_PORTAL.SCHEMATA;
	TRUNCATE TABLE QA3_LGCNS.SCHEMATA;
	TRUNCATE TABLE QA3_LGC.SCHEMATA;
	TRUNCATE TABLE QA3_LGES.SCHEMATA;
	
	TRUNCATE TABLE PRD_PORTAL.SCHEMATA;
	TRUNCATE TABLE PRD_LGCNS.SCHEMATA;
	TRUNCATE TABLE PRD_LGC.SCHEMATA;
	TRUNCATE TABLE PRD_LGES.SCHEMATA;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_INNODB_TABLES`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 13:30:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.INNODB_TABLES;
	TRUNCATE TABLE STG_LGCNS.INNODB_TABLES;
	TRUNCATE TABLE STG_LGC.INNODB_TABLES;
	TRUNCATE TABLE STG_LGES.INNODB_TABLES;

	TRUNCATE TABLE DEV_PORTAL.INNODB_TABLES;
	TRUNCATE TABLE DEV_LGCNS.INNODB_TABLES;
	TRUNCATE TABLE DEV_LGC.INNODB_TABLES;
	TRUNCATE TABLE DEV_LGES.INNODB_TABLES;
	
	TRUNCATE TABLE QA3_PORTAL.INNODB_TABLES;
	TRUNCATE TABLE QA3_LGCNS.INNODB_TABLES;
	TRUNCATE TABLE QA3_LGC.INNODB_TABLES;
	TRUNCATE TABLE QA3_LGES.INNODB_TABLES;
	
	TRUNCATE TABLE PRD_PORTAL.INNODB_TABLES;
	TRUNCATE TABLE PRD_LGCNS.INNODB_TABLES;
	TRUNCATE TABLE PRD_LGC.INNODB_TABLES;
	TRUNCATE TABLE PRD_LGES.INNODB_TABLES;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_INNODB_TABLESPACES`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 14:50:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.INNODB_TABLESPACES;
	TRUNCATE TABLE STG_LGCNS.INNODB_TABLESPACES;
	TRUNCATE TABLE STG_LGC.INNODB_TABLESPACES;
	TRUNCATE TABLE STG_LGES.INNODB_TABLESPACES;

	TRUNCATE TABLE DEV_PORTAL.INNODB_TABLESPACES;
	TRUNCATE TABLE DEV_LGCNS.INNODB_TABLESPACES;
	TRUNCATE TABLE DEV_LGC.INNODB_TABLESPACES;
	TRUNCATE TABLE DEV_LGES.INNODB_TABLESPACES;
	
	TRUNCATE TABLE QA3_PORTAL.INNODB_TABLESPACES;
	TRUNCATE TABLE QA3_LGCNS.INNODB_TABLESPACES;
	TRUNCATE TABLE QA3_LGC.INNODB_TABLESPACES;
	TRUNCATE TABLE QA3_LGES.INNODB_TABLESPACES;
	
	TRUNCATE TABLE PRD_PORTAL.INNODB_TABLESPACES;
	TRUNCATE TABLE PRD_LGCNS.INNODB_TABLESPACES;
	TRUNCATE TABLE PRD_LGC.INNODB_TABLESPACES;
	TRUNCATE TABLE PRD_LGES.INNODB_TABLESPACES;
END//
DELIMITER ;




DELIMITER //
CREATE EVENT `STG_PORTAL`.`EVNT_TRUNCATE_INNODB_INDEXES`
ON SCHEDULE EVERY 1 DAY STARTS '2022-09-06 16:10:00.000' ENDS '2038-01-19 03:14:07.000'
ON COMPLETION NOT PRESERVE
ENABLE
DO BEGIN
	TRUNCATE TABLE STG_PORTAL.INNODB_INDEXES;
	TRUNCATE TABLE STG_LGCNS.INNODB_INDEXES;
	TRUNCATE TABLE STG_LGC.INNODB_INDEXES;
	TRUNCATE TABLE STG_LGES.INNODB_INDEXES;

	TRUNCATE TABLE DEV_PORTAL.INNODB_INDEXES;
	TRUNCATE TABLE DEV_LGCNS.INNODB_INDEXES;
	TRUNCATE TABLE DEV_LGC.INNODB_INDEXES;
	TRUNCATE TABLE DEV_LGES.INNODB_INDEXES;
	
	TRUNCATE TABLE QA3_PORTAL.INNODB_INDEXES;
	TRUNCATE TABLE QA3_LGCNS.INNODB_INDEXES;
	TRUNCATE TABLE QA3_LGC.INNODB_INDEXES;
	TRUNCATE TABLE QA3_LGES.INNODB_INDEXES;
	
	TRUNCATE TABLE PRD_PORTAL.INNODB_INDEXES;
	TRUNCATE TABLE PRD_LGCNS.INNODB_INDEXES;
	TRUNCATE TABLE PRD_LGC.INNODB_INDEXES;
	TRUNCATE TABLE PRD_LGES.INNODB_INDEXES;
END//
DELIMITER ;