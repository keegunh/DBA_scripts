/*
Name					Description
pg_database				Stores general database info
pg_stat_database		Contains stats information of database
pg_tablespace			Contains Tablespace information
pg_operator				Contains all operator information
pg_available_extensions	List all available extensions
pg_shadow				List of all database users
pg_stats				Planner stats
pg_timezone_names	 	Time Zone names
pg_locks				Currently held locks
pg_tables	 			All tables in the database
pg_settings				Parameter Settings
pg_user_mappings		All user mappings
pg_indexes				All indexes in the database
pg_views	 			All views in the database.
*/
SELECT * FROM pg_database				;
SELECT * FROM pg_stat_database		    ;
SELECT * FROM pg_tablespace			    ;
SELECT * FROM pg_operator				;
SELECT * FROM pg_available_extensions	;
SELECT * FROM pg_shadow				    ;
SELECT * FROM pg_stats				    ;
SELECT * FROM pg_timezone_names	 	    ;
SELECT * FROM pg_locks				    ;
SELECT * FROM pg_tables	 			    ;
SELECT * FROM pg_settings				;
SELECT * FROM pg_user_mappings		    ;
SELECT * FROM pg_indexes				;
SELECT * FROM pg_views	 			    ;