SELECT transaction
     , gid
	 , prepared
	 , owner
	 , database
  FROM pg_prepared_xacts
 ORDER BY owner, database;