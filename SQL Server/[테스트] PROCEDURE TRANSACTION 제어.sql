CREATE TABLE ZZ_TEST(C1 NVARCHAR(1))
SELECT * FROM ZZ_TEST
GO
--C1�� INSERT �� C1�� C2�� ������Ʈ �ϴ� ���ν���
CREATE OR ALTER PROCEDURE [DBO].[ZZ_TEST_PROC](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    BEGIN TRY
		BEGIN TRAN INNER_PROC------------------------ TRANSACTION ����
        INSERT INTO DBO.ZZ_TEST VALUES(@C1)
		UPDATE DBO.ZZ_TEST SET C1 = @C2 WHERE C1 = @C1;
		COMMIT TRAN INNER_PROC------------------- TRANSACTION ���� : Ŀ��
		PRINT 'SUCCESS_INNER'
    END TRY  
  
    BEGIN CATCH
		ROLLBACK TRAN INNER_PROC----------------- TRANSACTION ���� : �ѹ�
		PRINT 'ERROR_INNER'
    END CATCH  
END  
GO


--TEST 1 : BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ��� �ּ� ó�� �� �Ʒ��� ���� EXECUTE
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC 'A', 'B'
SELECT * FROM ZZ_TEST;

--���
--C1
--B
--���� : 'A'�� 'B'�� ���̰� ���� ������ ������Ʈ �ȴ�. INSERT�� UPDATE ��� ����



--TEST 2 : BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ��� �ּ� ó�� �� �Ʒ��� ���� EXECUTE
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC 'A', 'BB'
SELECT * FROM ZZ_TEST;

--���
--C1
--A
--���� : 'A'�� 'BB'�� ���̰� �ٸ��� ������ ������Ʈ�� ���������� INSERT�� �����Ѵ�. BEGIN TRAN���� ���� �ʾұ� ������ INSERT�� ����, UPDATE�� ����.


--TEST 3 : BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ��� �ּ� ���� �� �Ʒ��� ���� EXECUTE
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC 'A', 'BB'
SELECT * FROM ZZ_TEST;

--���
--C1
--B
--���� : 'A'�� 'BB'�� ���̰� �ٸ��� ������ ������Ʈ ����. BEGIN TRAN���� ������ ������ INSERT�� UPDATE ��� ����


/*  ���: 
	INSERT �� UPDATE�� BEGIN TRAN - COMMIT TRAN ���� ���� ������ ���ν��� ���� �� ���� �߻� �� �����Ͱ� ���ϰ����� ���¿� ���̰� �ǹǷ�
    ������ TRANSACTION�� ��� ����� �Ѵ�.  
	BEGIN TRY ���� �κп� BEGIN TRAN ���� 
	BEGIN TRY ���� COMMIT TRAN ����
	BEGIN CATCH ���� �κп� ROLLBACK TRAN ����
	���� : BEGIN TRAN�� BEGIN TRY ������ ������ TRY ������ ���� �߻� �� Ʈ����� ��ü�� �ƴ϶� ������ ���� �ϳ��� ROLLBACK ó����.
*/




GO
-- ���� PROCEDURE ���� TRANSACTION ��� �ϴ� PROCEDURE �� �ϳ� �� �ִٸ�?
CREATE OR ALTER PROCEDURE [DBO].[ZZ_TEST_PROC2](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2),
	 @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    BEGIN TRY
		BEGIN TRAN  OUTER_PROC------------------------ TRANSACTION ����
        INSERT INTO DBO.ZZ_TEST VALUES(@C1)

		EXEC ZZ_TEST_PROC @V1, @V2

		UPDATE DBO.ZZ_TEST SET C1 = @C2 WHERE C1 = @C1
		COMMIT TRAN  OUTER_PROC------------------- TRANSACTION ���� : Ŀ��
		PRINT 'SUCCESS_OUTER'
    END TRY  
  
    BEGIN CATCH
		ROLLBACK TRAN  OUTER_PROC----------------- TRANSACTION ���� : �ѹ�
		PRINT 'ERROR_OUTER'
    END CATCH  
END  
GO
-- TEST1 : �ܺ�, ���� PROCEDURE���� BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ����ϴ� ���¿��� �Ʒ��� ���� EXECUTE. �ܺ� PROCEDURE ����, ���� PROCEDURE�� ����, TRANSACTION ���� �������� ���� ���.
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC2 'A', 'B', 'C', 'D'
SELECT * FROM ZZ_TEST;

--���
--C1
--B
--D
--���� : ���� ���� ����ȴٸ� ���� PROCEDURE, �ܺ� PROCEDURE ��� ���������� �ݿ�.


-- TEST2 : �ܺ�, ���� PROCEDURE���� BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ����ϴ� ���¿��� �Ʒ��� ���� EXECUTE. �ܺ� PROCEDURE ����, ���� PROCEDURE�� ����, TRANSACTION ���� �������� ���� ���.
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC2 'A', 'BB', 'C', 'D'
SELECT * FROM ZZ_TEST;

--���
--C1
--(����)
--���� : �ܺ� ���ν��� ���� �� ���� ���ν����� �����̶� �ϴ��� TRANSACTION�� ����


-- TEST3 : �ܺ�, ���� PROCEDURE���� BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ����ϴ� ���¿��� �Ʒ��� ���� EXECUTE. �ܺ� PROCEDURE ����, ���� PROCEDURE�� ����, TRANSACTION ���� �������� ���� ���.
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC2 'A', 'B', 'C', 'DD'
SELECT * FROM ZZ_TEST;

--���
--C1
--(����)

--�޽���
--ERROR_INNER
--�޽��� 3903, ���� 16, ���� 1, ���ν��� ZZ_TEST_PROC2, �� 25 [��ġ ���� �� 129]
--ROLLBACK TRANSACTION ��û�� �ش��ϴ� BEGIN TRANSACTION�� �����ϴ�.
--ERROR_OUTER

--���� : �ܺ� PROCEDURE ���� �߻� �� ���� PROCEDURE�� CATCH ���� Ÿ�� ROLLBACK ������ �� �ܺ� TRANSACTION�� CATCH������ ROLLBACK�� �� �����ϱ� ������ ���� ���� �޽��� �߻�. 
--�̷� ���� ���� ���ν����� �ܺ� ���ν������� TRANSACTION ��ɾ�(BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN) ���� �� TRANSACTION �̸����� �������ָ�
--�ش� TRANSACTION �̸��� �´� ��ġ�� �����ϰ� �ȴ�.




-- TEST4 : �ܺ�, ���� PROCEDURE���� BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN ����ϴ� ���¿��� �Ʒ��� ���� EXECUTE. �ܺ� PROCEDURE ����, ���� PROCEDURE�� ����, TRANSACTION ���� ������ ���.
TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC2 'A', 'B', 'C', 'DD'
SELECT * FROM ZZ_TEST;

--���
--C1
--(����)

--�޽���
--ERROR_OUTER

--���� : �ܺ� PROCEDURE ���� �߻� �� ���� PROCEDURE�� CATCH ���� Ÿ�� ROLLBACK ������ �� �ܺ� TRANSACTION�� CATCH������ ROLLBACK�� �� �����ϱ� ������ ���� ���� �޽��� �߻�. 
--�̷� ���� ���� ���ν����� �ܺ� ���ν������� TRANSACTION ��ɾ�(BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN) ���� �� TRANSACTION �̸����� �������ָ�
--�ش� TRANSACTION �̸��� �´� ��ġ�� �����ϰ� �ȴ�.


/* ���2
	BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN�� TRANSACTION�� ��ø���� ���� ���� TRANSACTION���� �������ִ� �� ����.
	TRANSACTION ������ ��� ����?
	TRANSACTION�� ��ø���� �� ROLLBACK�� 
*/

BEGIN TRAN






TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC3 'A', 'B', 'C', 'D'
SELECT * FROM ZZ_TEST;



TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC3 'A', 'BB', 'C', 'D'
SELECT * FROM ZZ_TEST;


TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC3 'A', 'B', 'C', 'DD'
SELECT * FROM ZZ_TEST;


TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC3 'A', 'BB', 'C', 'DD'
SELECT * FROM ZZ_TEST;


--ȣ�� ��ο��� Ʈ����� �̸��� ��ġ�� Ʈ����� ���� ó���� �� ������ �߻���. Ʈ����Ǹ��� �� �ᵵ ��������.
--�ٱ��� Ʈ������� �ѹ�Ǹ� ���� Ʈ������� Ŀ���� �ߴ��� �ѹ��
--Ʈ����Ǹ� : ���ν�����_TXN01
GO
CREATE OR ALTER PROCEDURE [DBO].[ZZ_TEST_PROC3](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2),
	 @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    BEGIN TRY
		BEGIN TRAN ZZ_TEST_PROC3_T1--OUTER_PROC------------------------ TRANSACTION ����
        INSERT INTO DBO.ZZ_TEST VALUES(@C1)

print 'A'

		BEGIN TRY
			BEGIN TRAN ZZ_TEST_PROC3_T2--INNER_PROC------------------------ TRANSACTION ����
			INSERT INTO DBO.ZZ_TEST VALUES(@V1)
print 'B'
			UPDATE DBO.ZZ_TEST SET C1 = @V2 WHERE C1 = @V1;
print 'C'
			COMMIT TRAN ZZ_TEST_PROC3_T2--INNER_PROC------------------- TRANSACTION ���� : Ŀ��
			PRINT 'SUCCESS_INNER'
		END TRY  
		BEGIN CATCH
print 'hello'
			ROLLBACK TRAN ZZ_TEST_PROC3_T2--INNER_PROC----------------- TRANSACTION ���� : �ѹ�
			PRINT 'ERROR_INNER'
		END CATCH  

print 'D'

		UPDATE DBO.ZZ_TEST SET C1 = @C2 WHERE C1 = @C1
print 'E'
		COMMIT TRAN  ZZ_TEST_PROC3_T1--OUTER_PROC------------------- TRANSACTION ���� : Ŀ��
		PRINT 'SUCCESS_OUTER'
    END TRY  
  
    BEGIN CATCH
print 'F'
		ROLLBACK TRAN  ZZ_TEST_PROC3_T1--OUTER_PROC----------------- TRANSACTION ���� : �ѹ�
		PRINT 'ERROR_OUTER'
    END CATCH  
print 'G'
END  

GO
CREATE OR ALTER PROCEDURE [DBO].[ZZ_TEST_PROC3](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2),
	 @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    BEGIN TRY
		BEGIN TRAN T1--OUTER_PROC------------------------ TRANSACTION ����
        INSERT INTO DBO.ZZ_TEST VALUES(@C1)

		COMMIT TRAN  T1--OUTER_PROC------------------- TRANSACTION ���� : Ŀ��
		ROLLBACK TRAN  T1--OUTER_PROC----------------- TRANSACTION ���� : �ѹ�
    END TRY  
  
    BEGIN CATCH
		PRINT 'ERROR_OUTER'
    END CATCH  
END  
GO

TRUNCATE TABLE ZZ_TEST;
EXEC ZZ_TEST_PROC3 'A', 'B', 'C', 'D'
SELECT * FROM ZZ_TEST;













GO
CREATE OR ALTER PROCEDURE [DBO].[NBMCMP_SMPL2](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2),
	 @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    ------- �ܺ� ���ν��� ����
    BEGIN TRY
		BEGIN TRAN NBMCMP_SMPL2_TXN01
        INSERT INTO NBM_USER.ZZ_TEST VALUES(@C1)

		------- ���� ���ν��� ����
		BEGIN TRY
			BEGIN TRAN NBMCMP_SMPL2_TXN02
			INSERT INTO NBM_USER.ZZ_TEST VALUES(@V1)
			UPDATE NBM_USER.ZZ_TEST SET C1 = @V2 WHERE C1 = @V1  -- ���� �߻�1
			COMMIT TRAN NBMCMP_SMPL2_TXN02
			PRINT 'SUCCESS_INNER'
		END TRY  
		BEGIN CATCH
			ROLLBACK TRAN NBMCMP_SMPL2_TXN02
			PRINT 'ERROR_INNER'
		END CATCH  
		------- ���� ���ν��� ��

		UPDATE NBM_USER.ZZ_TEST SET C1 = @C2 WHERE C1 = @C1  -- ���� �߻�2
		COMMIT TRAN  NBMCMP_SMPL2_TXN01
		PRINT 'SUCCESS_OUTER'
    END TRY  
  
    BEGIN CATCH
		ROLLBACK TRAN  NBMCMP_SMPL2_TXN01
		PRINT 'ERROR_OUTER'
    END CATCH  
	------- �ܺ� ���ν��� ��
END  
GO















--https://www.mssqltips.com/sqlservertip/4018/sql-server-transaction-count-after-execute-indicates-a-mismatching-number-of-begin-and-commit-statements/
GO
CREATE OR ALTER PROCEDURE [DBO].[ZZ_OUTER](  
     @C1  NVARCHAR(1),
	 @C2  NVARCHAR(2),
	 @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
  
    ------- �ܺ� ���ν��� ����
	PRINT 'OUTER: BEGIN_TRY'
    BEGIN TRY
		BEGIN TRAN  TXN01

		DROP TABLE IF EXISTS #TEMP;
		SELECT 9 AS C1 INTO #TEMP;
		INSERT INTO ZZ_TEST SELECT C11 FROM #TEMP; -- FATAL ERROR. C11�� #TEMP ���̺� ���� �÷���. 
		                                           -- �ش� ���� �߻� �� CATCH������ ������ �ʰ� Ʈ������� �ش� �������� ������. 
		                                           -- �������̴� Ʈ������� ������ ROLLBACK�̳� COMMIT ����� ��.

        INSERT INTO ZZ_TEST VALUES(@C1)

		------- ���� ���ν��� ����
		EXEC ZZ_INNER @V1, @V2
		------- ���� ���ν��� ��

		UPDATE ZZ_TEST SET C1 = @C2 WHERE C1 = @C1  -- ���� �߻�2
		COMMIT TRAN  TXN01
		
	PRINT 'OUTER: END_TRY'  
    END TRY  
    BEGIN CATCH
	PRINT 'OUTER: BEGIN_CATCH'  
		PRINT 'OUTER ERROR MSG : ' + ERROR_MESSAGE()
		ROLLBACK TRAN  TXN01
		PRINT 'OUTER ERROR MSG : ' + ERROR_MESSAGE()
	PRINT 'OUTER: END_CATCH'  
    END CATCH  
	------- �ܺ� ���ν��� ��
END  
GO

CREATE OR ALTER PROCEDURE [DBO].[ZZ_INNER](  
     @V1  NVARCHAR(1),
	 @V2  NVARCHAR(2)
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  

	--INSERT INTO ZZ_TEST VALUES(@V1)
	--UPDATE ZZ_TEST SET C1 = @V2 WHERE C1 = @V1  -- ���� �߻�1
  
		--------- ���� ���ν��� ����
		BEGIN TRY
			PRINT 'INNER : BEGIN_TRY'
			BEGIN TRANSACTION  TXN02
			INSERT INTO ZZ_TEST VALUES(@V1)
			UPDATE ZZ_TEST SET C1 = @V2 WHERE C1 = @V1  -- ���� �߻�1

			COMMIT TRANSACTION  TXN02
			PRINT 'INNER : END_TRY'
		END TRY  

		BEGIN CATCH
			PRINT 'INNER : BEGIN_CATCH'
			PRINT 'INNER ERROR MSG : ' + ERROR_MESSAGE()
			ROLLBACK TRANSACTION  TXN02
			PRINT 'INNER ERROR MSG : ' + ERROR_MESSAGE()
			PRINT 'INNER : END_CATCH'
		END CATCH  
		--------- ���� ���ν��� ��
END  
GO




--TEST
TRUNCATE TABLE ZZ_TEST
EXEC ZZ_OUTER 'A', 'B', 'C', 'D'
SELECT * FROM ZZ_TEST

DROP TABLE IF EXISTS ZZ_TEST
DROP TABLE IF EXISTS NBM_USER.ZZ_TEST
DROP PROCEDURE IF EXISTS ZZ_TEST_PROC
DROP PROCEDURE IF EXISTS ZZ_TEST_PROC2
DROP PROCEDURE IF EXISTS ZZ_TEST_PROC3
DROP PROCEDURE IF EXISTS NBMCMP_SMPL3
DROP PROCEDURE IF EXISTS ZZ_OUTER
DROP PROCEDURE IF EXISTS ZZ_INNER



BEGIN TRAN TXN01
BEGIN TRAN TXN02
ROLLBACK TRAN TXN02
ROLLBACK TRAN TXN01