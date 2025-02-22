/*
* 용도       : DB 인덱스 DDL 추출 (PK 제외)
* 수행DB     : -
* 마지막수정일자 : 2022.01.25
*
* 1. FN_EXTRACT_TABLE_DDL function의 owner 로 접속 필요 (PMPBDBA)
* 2. orange, sqlplus에서 실행 가능
* 3. UTL_DIR 디렉토리 사전 생성 필요
*    -> CREATE OR REPLACE DIRECTORY UTL_DIR AS '/oraful/HKG_TEST/utl_dir'; -- SYS 또는 SYSDBA로 수행 필요
*    -> SELECT * FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'UTL_DIR';
* 
*/
SET LONG 300000
SET LINESIZE 400
SET PAGESIZE 0
COL FILENAME FORMAT A40
COL DDL FORMAT A300

DECLARE
  FHANDLE  UTL_FILE.FILE_TYPE;
BEGIN
    FOR CUR_DDL IN (	   
      SELECT /*+FULL(A) PARALLEL(A 8) */
             A.INDEX_NAME || '.sql' AS FILENAME
           , TO_CLOB('CREATE ' || DECODE(A.UNIQUENESS, 'UNIQUE', 'UNIQUE', NULL) || ' INDEX "' || A.OWNER || '"."' || A.INDEX_NAME || '" ON "' || A.OWNER || '"."' || A.TABLE_NAME || '" ("' || 
             LISTAGG(C.COLUMN_NAME, '", "') WITHIN GROUP(ORDER BY C.COLUMN_POSITION) || '") ' || CHR(13) || CHR(10) || 
             DECODE(A.PARTITIONED, 'YES', 'LOCAL', NULL) || ' TABLESPACE ' || NVL(A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME) ||' PARALLEL 16 NOLOGGING;' || CHR(13) || CHR(10) || 
             'ALTER INDEX ' || A.OWNER || '.' || A.INDEX_NAME || ' NOPARALLEL LOGGING;') AS DDL
        FROM DBA_INDEXES A
           , DBA_PART_INDEXES B
           , DBA_IND_COLUMNS C
       WHERE A.OWNER = B.OWNER (+)
         AND A.INDEX_NAME = B.INDEX_NAME (+)
         AND A.OWNER = C.INDEX_OWNER 
         AND A.INDEX_NAME = C.INDEX_NAME
         AND NOT EXISTS (SELECT 1 FROM DBA_CONSTRAINTS D WHERE A.OWNER = D.OWNER AND A.INDEX_NAME = D.INDEX_NAME AND D.CONSTRAINT_TYPE = 'P')
         AND A.OWNER IN ('')
       GROUP BY A.OWNER, A.INDEX_NAME, A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME, A.UNIQUENESS, A.TABLE_NAME, A.PARTITIONED
	   ORDER BY 1
    )
    LOOP
        DBMS_XSLPROCESSOR.CLOB2FILE(CUR_DDL.DDL, 'UTL_DIR', CUR_DDL.FILENAME);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
    RAISE;
END;
/




-- 위 파일을 Windows에서 조회한다면 아래 변환 작업 필요 없음. (Notepad++ 로 정상 조회 가능)
-- Linux에서 조회 시 아래 변환 필요.
-----------------------------------------------------------------
#!/bin/bash
#input encoding
FROM_ENCODING="EUC-KR"
#output encoding(UTF-8)
TO_ENCODING="UTF-8"
#convert
CONVERT=" iconv  -f   $FROM_ENCODING  -t   $TO_ENCODING"

mkdir ./utf8

#loop to convert multiple files 
for  file  in  *.sql; do
     echo "converting file : $file"
     $CONVERT   "$file"   -o  "./utf8/${file}"
done

cd ./utf8
find . -type f | xargs -Ix sed -i -r 's/
//g' x

zip -r index_ddl.zip .
exit 0
-----------------------------------------------------------------
--[^M] 을 vi에서 없애려면 :%s/
//g 입력