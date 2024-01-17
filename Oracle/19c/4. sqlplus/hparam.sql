SET LINES 200 PAGES 1000
COL TYPE FORMAT A10
COL NAME FORMAT A35
COL VALUE FORMAT A40
COL DEFAULT_VALUE FORMAT A30
COL ISDEFAULT FORMAT A9
COL DESCRIPTION FORMAT A70

SELECT A.KSPPINM NAME
	 , B.KSPPSTVL "VALUE"
	 , B.KSPPSTDFL DEFAULT_VALUE
	 , B.KSPPSTDF ISDEFAULT
     , A.KSPPDESC DESCRIPTION
  FROM X$KSPPI A, X$KSSPPSV B
 WHERE A.INDX = B.INDX
   AND A.KSPPINM IN (
  '_add_col_optim_enabled'
, '_clusterwide_global_transactions'
, '_enable_NUMA_optimization'
, '_db_block_numa'
, '_optim_peek_user_binds'
, '_optimizer_use_feedback'
, '_undo_autotune'
, '_cleanup_rollback_entries'
, '_rollback_segment_count'
, '_gc_undo_affinity'
, '_in_memory_undo'
, '_px_use_large_pool'
, '_gc_policy_time'
, '_gc_integrity_checks'
)
   -- AND A.KSPPINM LIKE '%%';
 ORDER BY A.KSPPINM;
