SELECT r.rolname
     , nsp.nspname
	 , defaclobjtype
	 , defaclacl
  FROM pg_default_acl
  LEFT JOIN pg_namespace nsp
    ON nsp.oid=defaclnamespace
  LEFT JOIN pg_roles r
    ON r.oid=defaclrole;