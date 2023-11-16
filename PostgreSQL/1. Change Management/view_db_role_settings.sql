SELECT db.datname
     , r.rolname
	 , setconfig
  FROM pg_db_role_setting
  LEFT JOIN pg_database db
    ON db.oid=setdatabase
  LEFT JOIN pg_roles r
    ON r.oid=setrole;