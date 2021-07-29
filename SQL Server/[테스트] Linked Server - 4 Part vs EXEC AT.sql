---------------------------------------------------------------------------------------------------------
-- 1. 4 Part 방식 : 사용하지 말아야 함 - 인덱스/NOLOCK 다 적용 안됨(CPU/IO 과다 사용) 
SELECT *
  FROM [LinkedServer].[DB].[Schema].[Table] as A WITH(NOLOCK)
 WHERE A.EMPLOYEE_CD = '12345'
   AND A.DEPARTMENT_CD = '1111'

---------------------------------------------------------------------------------------------------------

-- 2. EXEC AT {linked_server_name}  : 사용해야 하는 방식임. 인덱스/NOLOCK  다 적용됨
DECLARE @EMPLOYEE_CD        NVARCHAR(4)  = '12345'
        , @DEPARTMENT_CD   NVARCHAR(10) = '1111'

EXEC ('
SELECT ...
  FROM [DB].[Schema].[Table] as A WITH(NOLOCK)
 WHERE A.EMPLOYEE_CD = ?
   AND A.DEPARTMENT_CD = ?
', @EMPLOYEE_CD, @DEPARTMENT_CD) AT [LinkedServer]

---------------------------------------------------------------------------------------------------------
-- 3. EXEC AT {linked_server_name} 결과를 변수로 Output
DECLARE @EMPLOYEE_CD        NVARCHAR(4) = '12345'
        , @DEPARTMENT_CD   NVARCHAR(10) = '1111'
        , @TEAM_CD NVARCHAR(10) = ''
EXEC ('
SELECT TOP 1 ? = TEAM_CD
  FROM [DB].[Schema].[Table] as A WITH(NOLOCK)
 WHERE A.EMPLOYEE_CD = ?
   AND A.DEPARTMENT_CD = ?
', @TEAM_CD OUTPUT, @EMPLOYEE_CD, @DEPARTMENT_CD) AT [LinkedServer]

SELECT @TEAM_CD as TEAM_CD


---------------------------------------------------------------------------------------------------------
-- 4. EXEC AT {linked_server_name} 결과를 임시 테이블로 Output
    INSERT INTO #TEMP_TABLE
    EXEC ('
   SELECT ...
     FROM [DB].[Schema].[Table] as A WITH(NOLOCK)
    WHERE A.EMPLOYEE_CD = ?
      AND A.DEPARTMENT_CD = ?
   ', @EMPLOYEE_CD, @DEPARTMENT_CD) AT [LinkedServer]
