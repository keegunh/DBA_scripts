## POWERSHELL
## 운영 DB slow query 확인

cd C:\Users\80517\Desktop\daily_check\slow_query
$TodayUTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
echo ".GCP Cloud SQL Production DB Slow Query Check" > PORTAL-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".Today's UTC date is ${TodayUTC}" >> PORTAL-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".GCP Cloud SQL Production DB Slow Query Check" > LGCNS-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".Today's UTC date is ${TodayUTC}" >> LGCNS-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".GCP Cloud SQL Production DB Slow Query Check" > LGC-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".Today's UTC date is ${TodayUTC}" >> LGC-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".GCP Cloud SQL Production DB Slow Query Check" > LGES-SLOW-QUERY-${TodayUTC}-tmp.txt
echo ".Today's UTC date is ${TodayUTC}" >> LGES-SLOW-QUERY-${TodayUTC}-tmp.txt


## PRD PORTAL
## echo "`n#PRD PORTAL" >> SLOW-QUERY-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-316104
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-316104/logs/cloudsql.googleapis.com%2Fmysql-slow.log" --limit 1000 --format "table(resource.labels.database_id, insertId, timestamp, textPayload)" >> PORTAL-SLOW-QUERY-${TodayUTC}-tmp.txt

## PRD LGCNS
## echo "`n#PRD LGCNS" >> SLOW-QUERY-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-cns
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-cns/logs/cloudsql.googleapis.com%2Fmysql-slow.log" --limit 1000 --format "table(resource.labels.database_id, insertId, timestamp, textPayload)" >> LGCNS-SLOW-QUERY-${TodayUTC}-tmp.txt

## PRD LGC
## echo "`n#PRD LGC" >> SLOW-QUERY-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-lgc
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lgc/logs/cloudsql.googleapis.com%2Fmysql-slow.log" --limit 1000 --format "table(resource.labels.database_id, insertId, timestamp, textPayload)" >> LGC-SLOW-QUERY-${TodayUTC}-tmp.txt

## PRD LGES
## echo "`n#PRD LGES" >> SLOW-QUERY-${TodayUTC}.txt
gcloud config set project pjt-hrcore-prd-lges
gcloud logging read "resource.type=cloudsql_database AND logName=projects/pjt-hrcore-prd-lges/logs/cloudsql.googleapis.com%2Fmysql-slow.log" --limit 1000 --format "table(resource.labels.database_id, insertId, timestamp, textPayload)" >> LGES-SLOW-QUERY-${TodayUTC}-tmp.txt

Get-Content .\PORTAL-SLOW-QUERY-${TodayUTC}-tmp.txt | sort > PORTAL-SLOW-QUERY-${TodayUTC}.txt
Get-Content .\LGCNS-SLOW-QUERY-${TodayUTC}-tmp.txt | sort > LGCNS-SLOW-QUERY-${TodayUTC}.txt
Get-Content .\LGC-SLOW-QUERY-${TodayUTC}-tmp.txt | sort > LGC-SLOW-QUERY-${TodayUTC}.txt
Get-Content .\LGES-SLOW-QUERY-${TodayUTC}-tmp.txt | sort > LGES-SLOW-QUERY-${TodayUTC}.txt

rm PORTAL-SLOW-QUERY-${TodayUTC}-tmp.txt
rm LGCNS-SLOW-QUERY-${TodayUTC}-tmp.txt
rm LGC-SLOW-QUERY-${TodayUTC}-tmp.txt
rm LGES-SLOW-QUERY-${TodayUTC}-tmp.txt