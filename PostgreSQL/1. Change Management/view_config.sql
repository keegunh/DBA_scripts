SELECT name
     , setting
	 , unit
	 , short_desc
	 , extra_desc
	 , boot_val
	 , reset_val
	 , sourcefile
	 , sourceline
	 , context
	 , vartype
	 , source
	 , min_val
	 , max_val
  FROM pg_settings
 -- WHERE source <> 'default'
 ORDER BY name;
 