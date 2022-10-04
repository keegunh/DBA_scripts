## POWERSHELL
## 매일 운영DB 에러로그 10건씩 확인

cd C:\Users\80517\Desktop\daily_check\error_log
$TodayUTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
echo "GCP Cloud SQL Production DB Daily Status Check" > ERROR-CHECK-${TodayUTC}.txt
echo "Today's UTC date is ${TodayUTC}" >> ERROR-CHECK-${TodayUTC}.txt

## PRD JJOBS, SPICEWARE, CORE, PORTAL
echo "`n#PRD SPICEWARE, CORE, PORTAL" >> ERROR-CHECK-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-316104
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-316104/logs/cloudsql.googleapis.com%2Fmysql.err" --limit 10 --format "table(resource.labels.database_id, textPayload)" >> ERROR-CHECK-${TodayUTC}.txt

echo "`n#PRD JJOBS" >> ERROR-CHECK-${TodayUTC}.txt
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-316104/logs/cloudsql.googleapis.com%2Fpostgres.log AND severity=ERROR" --limit 10 --format "table(resource.labels.database_id, textPayload)" >> ERROR-CHECK-${TodayUTC}.txt

## PRD LGCNS
echo "`n#PRD LGCNS" >> ERROR-CHECK-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-cns
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-cns/logs/cloudsql.googleapis.com%2Fmysql.err" --limit 10 --format "table(resource.labels.database_id, textPayload)" >> ERROR-CHECK-${TodayUTC}.txt

## PRD LGC
echo "`n#PRD LGC" >> ERROR-CHECK-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-lgc
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lgc/logs/cloudsql.googleapis.com%2Fmysql.err" --limit 10 --format "table(resource.labels.database_id, textPayload)" >> ERROR-CHECK-${TodayUTC}.txt

## PRD LGES
echo "`n#PRD LGES" >> ERROR-CHECK-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-lges
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lges/logs/cloudsql.googleapis.com%2Fmysql.err" --limit 10 --format "table(resource.labels.database_id, textPayload)" >> ERROR-CHECK-${TodayUTC}.txt