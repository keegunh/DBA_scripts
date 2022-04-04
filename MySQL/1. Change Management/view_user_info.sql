SELECT 
       host
	 , user
	 , plugin
	 , authentication_string
	 , password_last_changed
	 , account_locked
  FROM mysql.user
 WHERE plugin = 'mysql_native_password';

SHOW VARIABLES LIKE '%AUTHENTICATION%';