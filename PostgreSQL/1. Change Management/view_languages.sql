SELECT lanname
     , lanispl
     , lanpltrusted
     , lanacl
  FROM pg_language
 ORDER BY lanname;