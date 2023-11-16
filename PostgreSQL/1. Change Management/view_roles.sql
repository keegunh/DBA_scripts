SELECT rolname
     , rolsuper
	 , rolinherit
	 , rolcreaterole
	 , rolcreatedb
	 , rolcatupdate
	 , rolcanlogin
	 , rolconnlimit
	 , rolreplication
	 , rolvaliduntil
	 , rolconfig 
  FROM pg_roles
 ORDER BY rolname;