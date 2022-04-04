SET DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%

gcloud sql export sql csql-an3-hrcore-portal-stg-mysql gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/STG_PORTAL_CM_USER_LOGIN_%DATE%.sql --database=ERPAPP --table=CM_USER_LOGIN
REM gcloud sql export sql csql-an3-hrcore-lgc-stg-mysql    gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/STG_LGC_CM_USER_LOGIN_%DATE%.sql    --database=ERPAPP --table=CM_USER_LOGIN
REM gcloud sql export sql csql-an3-hrcore-lgcns-stg-mysql  gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/STG_LGCNS_CM_USER_LOGIN_%DATE%.sql  --database=ERPAPP --table=CM_USER_LOGIN
REM gcloud sql export sql csql-an3-hrcore-lges-stg-mysql   gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/STG_LGES_CM_USER_LOGIN_%DATE%.sql   --database=ERPAPP --table=CM_USER_LOGIN
REM gcloud sql export sql csql-an3-hrcore-core-stg-mysql   gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/STG_CORE_CM_USER_LOGIN_%DATE%.sql   --database=ERPAPP --table=CM_USER_LOGIN

gcloud sql operations list --instance csql-an3-hrcore-portal-stg-mysql --filter %DATE% --filter "EXPORT" --limit 50
REM gcloud sql operations list --instance csql-an3-hrcore-lgc-stg-mysql --filter %DATE% --filter "EXPORT" --limit 50
REM gcloud sql operations list --instance csql-an3-hrcore-lgcns-stg-mysql --filter %DATE% --filter "EXPORT" --limit 50
REM gcloud sql operations list --instance csql-an3-hrcore-lges-stg-mysql --filter %DATE% --filter "EXPORT" --limit 50
REM gcloud sql operations list --instance csql-an3-hrcore-core-stg-mysql --filter %DATE% --filter "EXPORT" --limit 50

gsutil ls gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history | findstr %DATE%