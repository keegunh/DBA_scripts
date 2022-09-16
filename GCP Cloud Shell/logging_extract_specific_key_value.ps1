# GCP Logging 서비스에서 로그 파일을 JSON 파일로 다운 받은 후 
# 원하는 key-value만 추출하는 스크립트
# json 파일이 5000 라인을 넘어가면 오류 발생하는 것 같다.

$timeNow = Get-Date
$timeFormatted = $TimeNow.ToString("yyyyMMddHHmmss")

# 경로 및 파일명 설정
$inDir="C:\Users\80517\Downloads"
$jsonFile="downloaded-logs-20220915-150321"
$outDir="D:\2022 공통업무 상향 평준화 HR Core 프로젝트\스크립트\dba_private\GCP Cloud Shell\ConvertFrom-Json"
$resultFile="result_${timeFormatted}.sql"

echo "input json file : " ${inDir}\${jsonFile}.json
$json = (Get-Content ${inDir}\${jsonFile}.json -Raw) | ConvertFrom-Json
$json.psobject.Properties.Value.textPayload > ${outDir}\${resultFile}
echo "output result file : " ${outDir}\${resultFile}.json