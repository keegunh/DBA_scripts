SELECT * FROM GV$SQL_MONITOR WHERE USERNAME='' ORDER BY LAST_REFRESH_TIME DESC;
select dbms_sqltune.report_sql_monitor(sql_id=>'1sshgw3dvum8p',event_detail=>'YES', type => 'TEXT',report_level => 'ALL') from dual;
select dbms_sqltune.report_sql_monitor(sql_id=>'5m83g8fdycnwx',event_detail=>'YES', type => 'HTML', report_level => 'ALL') from dual;