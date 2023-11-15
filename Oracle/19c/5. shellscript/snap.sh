#! /bin/bash
sqlplus system/[SYSTEMPASSWORD]@DBNAME << EOF
exec dbms_workload_repository.create_snapshot();
EOF