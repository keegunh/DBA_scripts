DROP PROCEDURE IF EXISTS `ERPAPP`.`P_CREATE_BACKUP_TABLE`;
DELIMITER //
CREATE PROCEDURE `ERPAPP`.`P_CREATE_BACKUP_TABLE` (IN p_schema_name varchar(100), IN p_table_name varchar(100))
SQL SECURITY DEFINER
BEGIN
	-- DECLARE VARIABLES
	DECLARE v_create_stmt varchar(1000);
	DECLARE v_insert_stmt varchar(1000);
	DECLARE v_yyyymmdd varchar(8);

	-- DECLARE CONDITIONS
	DECLARE ER_TABLE_EXISTS_ERROR CONDITION FOR SQLSTATE '42S01';
	DECLARE ER_BAD_TABLE_ERROR CONDITION FOR SQLSTATE '42S02';

	-- DECLARE HANDLERS
	DECLARE EXIT HANDLER FOR ER_TABLE_EXISTS_ERROR
	BEGIN
		SET @sql_create = NULL;
		SET @sql_insert = NULL;
		SELECT CONCAT('Backup table already exists for date: ', v_yyyymmdd, '. (SQLSTATE 42S01)') AS ERROR_MESSAGE;
	END;
	DECLARE EXIT HANDLER FOR ER_BAD_TABLE_ERROR
	BEGIN
		SET @sql_create = NULL;
		SET @sql_insert = NULL;
		SELECT CONCAT('No such table exists. (SQLSTATE 42S02)') AS ERROR_MESSAGE;
	END;
		
	DECLARE EXIT HANDLER FOR SQLWARNING, SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SELECT 'Undefined HANDLER' AS ERROR_MESSAGE;
	END;	
	
	SET v_yyyymmdd = DATE_FORMAT(NOW(),'%Y%m%d');
	SET @sql_create = CONCAT('CREATE TABLE ', p_schema_name, '.', p_table_name, '_BACKUP_', v_yyyymmdd, ' LIKE ', p_schema_name, '.', p_table_name, ';' );
-- 	SELECT @sql_create AS CREATE_DDL;
	PREPARE v_create_stmt FROM @sql_create;
	EXECUTE v_create_stmt;
	DEALLOCATE PREPARE v_create_stmt;

	SET @sql_insert = CONCAT('INSERT INTO ', p_schema_name, '.', p_table_name, '_BACKUP_', v_yyyymmdd, ' SELECT * FROM ', p_schema_name, '.', p_table_name, ';' );
-- 	SELECT @sql_insert AS INSERT_DML;
	PREPARE v_insert_stmt FROM @sql_insert;
	EXECUTE v_insert_stmt;
	COMMIT;
	DEALLOCATE PREPARE v_insert_stmt;
	SET @sql_create = NULL;
	SET @sql_insert = NULL;
END//
DELIMITER ;