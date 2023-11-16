SELECT checkpoints_timed
     , checkpoints_req
     , buffers_checkpoint
     , buffers_clean
     , maxwritten_clean
     , buffers_backend
     , buffers_backend_fsync
     , buffers_alloc
     , date_trunc('second', stats_reset) as stats_reset
  FROM pg_stat_bgwriter;