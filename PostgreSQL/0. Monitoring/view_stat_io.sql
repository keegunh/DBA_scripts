/*
pg_stat_io is a system view which basically gives us a insight into I/o operations of postgresql systems.
This i/o can come from multiple sources or backend process.
Users may wish to explore client backend operations, or other backend operation types like Autovacuum.
I/o operations like tables and indexes are tracked.
Temporary tables are not fsynced and will appear to be null.
A high evictions count can indicate that shared buffers should be increased.
Syntax to reset pg_Stat_io
    SELECT pg_stat_reset_shared('io');

Normal: The default or standard context for a type of I/O operation. For example, reads and writes of relation data to and from shared buffers are tracked in context normal.
Vacuum: I/O operations performed outside of shared buffers while vacuuming and analyzing permanent relations. Temporary table vacuums use the same local buffer pool as other temporary table IO operations and are tracked in context normal.
Bulkread: Certain large read I/O operations done outside of shared buffers, for example, a sequential scan of a large table.
Bulkwrite: Certain large write I/O operations done outside of shared buffers, such as COPY.
*/

SELECT backend_type
     , object
	 , context
	 , reads
	 , writes
	 , extends
	 , op_bytes
	 , evictions
	 , hits
	 , reuses
	 , fsyncs 
  FROM pg_stat_io;