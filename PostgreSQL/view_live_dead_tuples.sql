select n.nspname as schema_name
	 , c.relname as table_name
	 , pg_stat_get_live_tuples(c.oid) + pg_stat_Get_dead_tuples(c.oid) as total_tuple
	 , pg_stat_get_live_tuples(c.oid) as live_tuple
	 , pg_stat_get_dead_tuples(c.oid) as dead_tuple
	 , round(100*pg_stat_get_live_tuples(c.oid) / (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)),2) as live_tuple_ratio
	 , round(100*pg_stat_get_dead_tuples(c.oid) / (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)),2) as dead_tuple_ratio
	 , pg_size_pretty(pg_total_relation_size(c.oid)) as total_relation_size
	 , pg_size_pretty(pg_relation_size(c.oid)) as relation_size
	 , 'vacuum analyze ' || n.nspname || '.' || c.relname || ';' as vacuum_cmd
  from pg_class as c
 inner join pg_catalog.pg_namespace as n 
    on n.oid = c.relnamespace
 where pg_stat_get_live_tuples(c.oid) > 0
   and n.nspname not in ('information_schema', 'pg_catalog', 'pg_toast')
 order by dead_tuple desc;