SELECT n.nspname
     , p.proname
     , CASE WHEN p.proretset THEN 'setof ' ELSE '' END || pg_catalog.format_type(p.prorettype, NULL) as returntype
     , CASE WHEN proallargtypes IS NOT NULL 
            THEN pg_catalog.array_to_string(ARRAY(SELECT CASE WHEN p.proargmodes[s.i] = 'i' THEN '' 
                                                              WHEN p.proargmodes[s.i] = 'o' THEN 'OUT '
                                                              WHEN p.proargmodes[s.i] = 'b' THEN 'INOUT '
                                                         END || 
                                                         CASE WHEN COALESCE(p.proargnames[s.i], '') = '' THEN ''
                                                              ELSE p.proargnames[s.i] || ' '
                                                         END || pg_catalog.format_type(p.proallargtypes[s.i], NULL)
                                                    FROM pg_catalog.generate_series(1, pg_catalog.array_upper(p.proallargtypes, 1)) AS s(i) ), ', ')
            ELSE pg_catalog.array_to_string(ARRAY(SELECT CASE WHEN COALESCE(p.proargnames[s.i+1], '') = '' THEN ''
                                                              ELSE p.proargnames[s.i+1] || ' '
                                                         END || pg_catalog.format_type(p.proargtypes[s.i], NULL)
                                                    FROM pg_catalog.generate_series(0, pg_catalog.array_upper(p.proargtypes, 1)) AS s(i) ), ', ')
       END AS args
     , CASE WHEN p.provolatile = 'i' THEN 'immutable'
            WHEN p.provolatile = 's' THEN 'stable'
            WHEN p.provolatile = 'v' THEN 'volatile'
       END as volatility
     , pg_get_userbyid(proowner) AS rolname
     , proleakproof
     , l.lanname
  FROM pg_catalog.pg_proc p
  LEFT JOIN pg_catalog.pg_namespace n
    ON n.oid = p.pronamespace
  LEFT JOIN pg_catalog.pg_language l
    ON l.oid = p.prolang
 WHERE p.prorettype <> 'pg_catalog.cstring'::pg_catalog.regtype
   AND (p.proargtypes[0] IS NULL
    OR p.proargtypes[0] <> 'pg_catalog.cstring'::pg_catalog.regtype)
   AND p.prokind in ('f') -- f: normal function, p: procedure, w: window function, a: aggregate function
 ORDER BY 1, 2, 3, 4;
 
SELECT schemaname
     , funcname
     , calls
     , total_time
     , self_time
  FROM pg_stat_user_functions
 ORDER BY schemaname, funcname;