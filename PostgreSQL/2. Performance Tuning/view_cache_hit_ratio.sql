SELECT datname
     , blks_read
     , blks_hit
     , round((blks_hit::float/(blks_read+blks_hit+1)*100)::numeric, 2) as cachehitratio
  FROM pg_stat_database
 ORDER BY datname, cachehitratio;