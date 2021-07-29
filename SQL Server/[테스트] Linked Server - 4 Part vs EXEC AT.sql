---------------------------------------------------------------------------------------------------------
-- 1. 4 Part ��� : ������� ���ƾ� �� - �ε���/NOLOCK �� ���� �ȵ�(CPU/IO ���� ���) 
SELECT *
  FROM [LinkedServer].[DB].[Schema].[Table] as A WITH(NOLOCK)
 WHERE A.EMPLOYEE_CD = '12345'
   AND A.DEPARTMENT_CD = '1111'

---------------------------------------------------------------------------------------------------------

-- 2. EXEC AT {linked_server_name}  : ����ؾ� �ϴ� �����. �ε���/NOLOCK  �� �����
DECLARE @EMPLOYEE_CD        NVARCHAR(4)  = '12345'
        , @DEPARTMENT_CD   NVARCHAR(10) = '1111'

EXEC ('
SELECT ...
  FROM [DB].[Schema].[Table] as A WITH(NOLOCK)
 WHERE A.EMPLOYEE_CD = ?
   AND A.DEPARTMENT_CD = ?
', @EMPLOYEE_CD, @DEPARTMENT_CD) AT [LinkedServer]

---------------------------------------------------------------------------------------------------------
-- 3. EXEC AT {linked_server_name} ����� ������ Output
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
-- 4. EXEC AT {linked_server_name} ����� �ӽ� ���̺�� Output
    INSERT INTO #TEMP_TABLE
    EXEC ('
   SELECT ...
     FROM [DB].[Schema].[Table] as A WITH(NOLOCK)
    WHERE A.EMPLOYEE_CD = ?
      AND A.DEPARTMENT_CD = ?
   ', @EMPLOYEE_CD, @DEPARTMENT_CD) AT [LinkedServer]
