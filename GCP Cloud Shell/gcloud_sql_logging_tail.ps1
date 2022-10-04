## POWERSHELL
## GCP Cloud Logging 로그 실시간 tail
## gcloud logging logs list

https://cloud.google.com/sdk/gcloud/reference/alpha/logging/tail
gcloud beta logging tail "resource.type=cloudsql_database AND severity>=ERROR" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s
gcloud beta logging tail "resource.type=cloudsql_database" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s

## PRD JJOBS, SPICEWARE, CORE, PORTAL
echo "`n#PRD SPICEWARE, CORE, PORTAL"
gcloud config set project pjt-hrcore-prd-316104
gcloud beta logging tail "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-316104/logs/cloudsql.googleapis.com%2Fmysql.err" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s

echo "`n#PRD JJOBS"
gcloud beta logging tail "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-316104/logs/cloudsql.googleapis.com%2Fpostgres.log AND severity=ERROR" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s

## PRD LGCNS
echo "`n#PRD LGCNS"
gcloud config set project pjt-hrcore-prd-cns
gcloud beta logging tail "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-cns/logs/cloudsql.googleapis.com%2Fmysql.err" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s

## PRD LGC
echo "`n#PRD LGC"
gcloud config set project pjt-hrcore-prd-lgc
gcloud beta logging tail "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lgc/logs/cloudsql.googleapis.com%2Fmysql.err" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s

## PRD LGES
echo "`n#PRD LGES"
gcloud config set project pjt-hrcore-prd-lges
gcloud beta logging tail "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lges/logs/cloudsql.googleapis.com%2Fmysql.err" --format="default(resource["labels"]["database_id"],text_payload)" --buffer-window=0s