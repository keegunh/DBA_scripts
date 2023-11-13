select name
     , setting
	 , unit
	 , category
	 , short_desc
  from pg_settings
 where name like '%%';