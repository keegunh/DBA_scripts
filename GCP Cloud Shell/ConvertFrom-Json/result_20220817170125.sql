# Time: 2022-08-17T01:11:22.633034Z
# User@Host: inorg[inorg] @  [10.2.183.116]  thread_id: 2350087  server_id: 4282968835
# Query_time: 9.730562  Lock_time: 0.000301 Rows_sent: 34  Rows_examined: 26364337
use INORG;
SET timestamp=1660698672;
SELECT *
        FROM
        (
            SELECT N.SORT
                , N.GRADE
                , (
                  		SELECT 	DEPARTMENT_NM
                  		FROM	HPE_PER_APP
                  		WHERE	EMP_ID = N.EMP_ID
								AND		START_DATE   <=   N.START_DATE
                  		ORDER BY START_DATE DESC
                  		LIMIT 1
                    ) AS ORG_NM
                , (
                  		SELECT 	DUTY_NM
                  		FROM	HPE_PER_APP
                  		WHERE	EMP_ID = N.EMP_ID
								AND		START_DATE   <=   N.START_DATE
                  		AND		DUTY_START_DATE IS NOT NULL
                  		ORDER BY START_DATE DESC
                  		LIMIT 1
                    ) AS DUTY_NM
                , (
                  		SELECT 	POS_NM
                  		FROM	HPE_PER_APP
                  		WHERE	EMP_ID = N.EMP_ID
								AND		START_DATE   <=   N.START_DATE
                  		AND		POS_START_DATE IS NOT NULL
                  		ORDER BY START_DATE DESC
                  		LIMIT 1
                  ) AS POS_NM
                , N.TYPE
                , N.START_DATE
                , TYPE_CODE.CODE_NAME AS AWARD
                , N.EMP_ID
                , FORMAT(N.NOTE,0) AS REWARD
            FROM    HRP_COMP_NON_RECURRING N
                    LEFT OUTER JOIN SFI_SVC_CODE R
                    ON  R.CODE_TYPE = 'SSP_DUTY_CD'
                    AND R.CODE = N.DUTY_NM
                    AND R.LANG_CD = IFNULL('ko_KR', null)
                    AND R.COMPANY_SEQ = 3219395
                    LEFT OUTER JOIN SFI_SVC_CODE TYPE_CODE
                    ON  TYPE_CODE.CODE_TYPE = 'SSP_PAY_COMPONENT_CD'
                    AND TYPE_CODE.CODE = N.TYPE
                    AND TYPE_CODE.LANG_CD = 'defaultValue'
                    AND TYPE_CODE.COMPANY_SEQ = 3219395
                    LEFT OUTER JOIN SFI_SVC_CODE CURRENCY
                    ON  CURRENCY.CODE_TYPE = 'SSP_CURRENCY_CD'
                    AND CURRENCY.CODE = N.GRADE
                    AND CURRENCY.LANG_CD = 'defaultValue'
                    AND CURRENCY.COMPANY_SEQ = 3219395
            WHERE   N.EMP_ID = '418014'
            AND     N.START_DATE   <=   NOW()
             
             
             
             
             
                UNION
                SELECT  A.AWARD_TYPE
                        , NULL
                        , APP.DEPARTMENT_NM
                        , APP.DUTY_NM
                        , APP.POS_NM
                        , A.AWARD_REASON
                        , DATE_FORMAT(A.START_DATE,'%Y-%m-%d')
                        , A.AWARD
                        , A.EMP_ID
                        , FORMAT(A.AWARD_REWARD,0) AS REWARD
                FROM    HPA_AWARDS A
                LEFT JOIN HPE_PER_APP APP
                ON  APP.SEQ = (
                    SELECT  APP_TEMP.SEQ
                    FROM    HPE_PER_APP APP_TEMP
                    WHERE   APP_TEMP.EMP_ID = A.EMP_ID
                    AND     APP_TEMP.START_DATE   <=   A.START_DATE
                    ORDER BY APP_TEMP.START_DATE DESC
                    LIMIT 1
                )
                AND APP.START_DATE   <=   A.START_DATE
                LEFT OUTER JOIN SFI_SVC_CODE R
                ON  R.CODE_TYPE = 'SSP_DUTY_CD'
                AND R.CODE = A.DUTY_NM
                AND R.LANG_CD = IFNULL('ko_KR', null)
                AND R.COMPANY_SEQ = 3219395
                WHERE   A.EMP_ID = '418014'
                AND     A.START_DATE   <=   NOW()
                AND     A.IMPORTANT = 'Y'
             
            ) T
            INNER JOIN SSP_EMP E
            ON T.EMP_ID = E.EMP_ID
            ORDER BY T.START_DATE DESC;
# Time: 2022-08-17T01:15:36.865610Z
# User@Host: erpconv[erpconv] @  [10.1.121.193]  thread_id: 2352224  server_id: 4282968835
# Query_time: 7.212514  Lock_time: 0.000371 Rows_sent: 46  Rows_examined: 1813188
use ERPAPP;
SET timestamp=1660698929;
SELECT * FROM HR_IF_ASG_HIST_SEND A
WHERE A.EMP_ID = 416453;
