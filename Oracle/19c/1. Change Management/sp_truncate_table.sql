CREATE OR REPLACE PROCEDURE PMPBADM."SP_PMPB_TRUNCATE" 
(
    V_IN_OWNER      IN  VARCHAR2,
    V_IN_TAB_NAME   IN  VARCHAR2,
    V_IN_PART_RANGE IN  VARCHAR2,
    gReturnFlag  OUT NUMBER
) IS
    V_OWNER         VARCHAR(10);     -- Owner
    V_PART_PREFIX   VARCHAR2(10);    -- 파티션테이블 Prefix
    V_use_yn      CHAR(1);         -- 사용여부
BEGIN
    DBMS_OUTPUT.put_line('### BEGIN ###');
    V_use_yn := 'N';
    SELECT TRUN_TRGT_TBL_OWNR_NM                -- Owner
            , TRUN_TRGT_TBL_PATN_PFIX_NM       -- 파티션테이블 Prefix
            , USE_YN          -- 사용여부
    INTO V_OWNER, V_PART_PREFIX, V_use_yn
    FROM pmpbadm.TB_PMPB_TRUN_TRGT_TBL_M
    WHERE TRUN_TRGT_TBL_OWNR_NM = V_IN_OWNER
        AND TRUN_TRGT_TBL_NM = V_IN_TAB_NAME ;

    IF (UPPER(V_use_yn) != 'Y') THEN
        gReturnFlag := -1;
    ELSE
        IF (LENGTH(V_IN_PART_RANGE) > 0) THEN
            EXECUTE IMMEDIATE 'ALTER TABLE '|| V_OWNER || '.' || V_IN_TAB_NAME || ' TRUNCATE PARTITION ' || V_PART_PREFIX || V_IN_PART_RANGE;
        ELSE
            EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || V_OWNER || '.' || V_IN_TAB_NAME;
        END IF;
        IF (SQLCODE = 0) THEN
            gReturnFlag := 0;
        ELSE
            DBMS_OUTPUT.put_line('CODE: '|| SQLCODE || SQLERRM);
            gReturnFlag := -1;
        END IF;
    END IF;
    DBMS_OUTPUT.put_line('### END ###');
EXCEPTION
   WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('CODE: '|| SQLCODE || SQLERRM);
        gReturnFlag := -1;
END;
/