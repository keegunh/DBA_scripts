SELECT loid
     , pg_get_userbyid(lomowner) AS owner
     , lomacl
     , totalblocks
  FROM pg_largeobject_metadata md
     , (SELECT loid
             , count(*) AS totalblocks
          FROM pg_largeobject
         GROUP BY 1
         ORDER BY 1) pg_largeobject
 WHERE md.oid=loid
 ORDER BY 1;