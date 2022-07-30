# 일일 백업 정상 생성 여부 확인
$timeNow = Get-Date
$timeFormatted = $TimeNow.ToString("yyyyMMddHHmmss")

# 경로 및 파일명 설정
$inDir="C:\Users\80517\Downloads"
$jsonFile="downloaded-logs-20220730-095829"
$outDir="D:\2022 공통업무 상향 평준화 HR Core 프로젝트\스크립트\dba_private\GCP Cloud Shell\ConvertFrom-Json"
$resultFile="result_${timeFormatted}.sql"

echo "input json file : " ${inDir}\${jsonFile}.json
$json = (Get-Content ${inDir}\${jsonFile}.json -Raw) | ConvertFrom-Json
$json.psobject.Properties.Value.textPayload > ${outDir}\${resultFile}				## textPayload는 추출하고 싶은 Key명. 이거 변경하면 다른 Key도 추출 가능.
echo "output result file : " ${outDir}\${resultFile}.json