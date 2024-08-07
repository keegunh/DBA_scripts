# Time: 2022-11-25T00:12:38.847270Z
# User@Host: inorg[inorg] @  [10.2.183.79]  thread_id: 9945722  server_id: 2886939016
# Query_time: 3.667335  Lock_time: 0.003188 Rows_sent: 6994  Rows_examined: 27716268
SET timestamp=1669335155;
SELECT	O.SEQ
					, O.REO_MANAGE_SEQ
					, O.ORG_POSITION_ID
					, O.UP_ORG_POSITION_ID
					, O.ORG_ID
					, ORG.ORG_NM
					, O.POSITION_ID
					, O.POSITION_NM
					, O.POSITION_NM1
					, O.POSITION_NM2
					, O.DUTY_CD
					, IFNULL(CD.CODE_NAME, CD2.CODE_NAME) AS DUTY_NM
					, C.OPT3 AS JOB_LEVEL
					, O.LEADER_YN
					, O.SORT_ORDER
					, O.TARGET_FTE  				 -- TARGET FTE
					, O.MULTI_ALLOWED 				-- 蹂듭닔諛곗튂?щ?
					, O.COST_CENTER
					, O.COST_CENTER_INHERIT
					, O.OPT1
					, O.OPT2
					, O.OPT3
					, O.OPT4
					, O.OPT5
					, O.IN_USER_ID
					, O.IN_DATE
					, O.UP_USER_ID
					, O.UP_DATE
			FROM	SSP_REO_POSITION_ORG O
					INNER JOIN SSP_REO_ORG ORG
					ON 	O.ORG_ID = ORG.ORG_ID
					AND O.REO_MANAGE_SEQ = ORG.REO_MANAGE_SEQ
					LEFT OUTER JOIN SFI_SVC_CODE C
					ON 	C.CODE_TYPE = 'SSP_JOB_CD'
					AND	C.CODE = O.POSITION_ID
					AND	C.LANG_CD = 'ko_KR'
					AND C.COMPANY_SEQ = '3219394'
					LEFT OUTER JOIN SFI_SVC_CODE CD
					ON 	CD.CODE_TYPE = 'SSP_DUTY_CD'
					AND	CD.CODE = O.DUTY_CD
					AND	CD.LANG_CD = 'ko_KR'
					AND CD.COMPANY_SEQ = '3219394'
					LEFT OUTER JOIN SFI_SVC_CODE CD2
					ON 	CD2.CODE_TYPE = 'SSP_DUTY_CD'
					AND	CD2.CODE = O.DUTY_CD
					AND	CD2.LANG_CD = 'defaultValue'
					AND CD2.COMPANY_SEQ = '3219394'
			WHERE	1=1
			 
					AND O.REO_MANAGE_SEQ = '227630435'
				 
			 
			 
					AND		(
						ORG.ORG_ID IN (
						WITH RECURSIVE TEMP AS
						(
							SELECT T.ORG_ID, T.UP_ORG_ID,  T.ORG_NM
							FROM (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM 	SSP_REO_ORG O
									LEFT JOIN SSP_REO_ORG_CHG C
									ON O.ORG_ID = C.ORG_ID
									AND C.REO_MANAGE_SEQ = '227630435'
									WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
									AND C.SEQ IS NULL
									UNION ALL
									SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM SSP_REO_ORG_CHG O
									WHERE O.REO_MANAGE_SEQ = '227630435') T
							WHERE 	(T.UP_ORG_ID =  '300001' OR T.ORG_ID = '300001')
							UNION
							SELECT T.ORG_ID, T.UP_ORG_ID, T.ORG_NM
							FROM TEMP W
							JOIN (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM 	SSP_REO_ORG O
									LEFT JOIN SSP_REO_ORG_CHG C
									ON O.ORG_ID = C.ORG_ID
									AND C.REO_MANAGE_SEQ = '227630435'
									WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
									AND C.SEQ IS NULL
									UNION ALL
									SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM SSP_REO_ORG_CHG O
									WHERE O.REO_MANAGE_SEQ = '227630435') T
									ON T.UP_ORG_ID = W.ORG_ID
						)
						SELECT ORG_ID FROM TEMP
					)
					OR
					O.ORG_POSITION_ID IN (
						SELECT ORG_POSITION_ID
						FROM SSP_REO_POSITION_ORG_CHG
						WHERE REO_MANAGE_SEQ = '227630435'
						AND ORG_ID IN (
							WITH RECURSIVE TEMP AS
						(
							SELECT T.ORG_ID, T.UP_ORG_ID,  T.ORG_NM
							FROM (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM 	SSP_REO_ORG O
									LEFT JOIN SSP_REO_ORG_CHG C
									ON O.ORG_ID = C.ORG_ID
									AND C.REO_MANAGE_SEQ = '227630435'
									WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
									AND C.SEQ IS NULL
									UNION ALL
									SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM SSP_REO_ORG_CHG O
									WHERE O.REO_MANAGE_SEQ = '227630435') T
							WHERE 	(T.UP_ORG_ID =  '300001' OR T.ORG_ID = '300001')
							UNION
							SELECT T.ORG_ID, T.UP_ORG_ID, T.ORG_NM
							FROM TEMP W
							JOIN (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM 	SSP_REO_ORG O
									LEFT JOIN SSP_REO_ORG_CHG C
									ON O.ORG_ID = C.ORG_ID
									AND C.REO_MANAGE_SEQ = '227630435'
									WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
									AND C.SEQ IS NULL
									UNION ALL
									SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
									FROM SSP_REO_ORG_CHG O
									WHERE O.REO_MANAGE_SEQ = '227630435') T
									ON T.UP_ORG_ID = W.ORG_ID
						)
						SELECT ORG_ID FROM TEMP
						)
					)
					)
				 
			UNION
			SELECT	O.SEQ
					, O.REO_MANAGE_SEQ
					, O.ORG_POSITION_ID
					, O.UP_ORG_POSITION_ID
					, O.ORG_ID
					, ORG.ORG_NM
					, O.POSITION_ID
					, O.POSITION_NM
					, O.POSITION_NM1
					, O.POSITION_NM2
					, O.DUTY_CD
					, IFNULL(CD.CODE_NAME, CD2.CODE_NAME) AS DUTY_NM
					, C.OPT3 AS JOB_LEVEL
					, O.LEADER_YN
					, O.SORT_ORDER
					, O.TARGET_FTE  				 -- TARGET FTE
					, O.MULTI_ALLOWED 				-- 蹂듭닔諛곗튂?щ?
					, O.COST_CENTER
					, O.COST_CENTER_INHERIT
					, O.OPT1
					, O.OPT2
					, O.OPT3
					, O.OPT4
					, O.OPT5
					, O.IN_USER_ID
					, O.IN_DATE
					, O.UP_USER_ID
					, O.UP_DATE
			FROM	SSP_REO_POSITION_ORG O
					INNER JOIN SSP_REO_ORG ORG
					ON O.ORG_ID = ORG.ORG_ID
					LEFT OUTER JOIN SFI_SVC_CODE C
					ON 	C.CODE_TYPE = 'SSP_JOB_CD'
					AND	C.CODE = O.POSITION_ID
					AND	C.LANG_CD = 'ko_KR'
					AND C.COMPANY_SEQ = '3219394'
					LEFT OUTER JOIN SFI_SVC_CODE CD
					ON 	CD.CODE_TYPE = 'SSP_DUTY_CD'
					AND	CD.CODE = O.DUTY_CD
					AND	CD.LANG_CD = 'ko_KR'
					AND CD.COMPANY_SEQ = '3219394'
					LEFT OUTER JOIN SFI_SVC_CODE CD2
					ON 	CD2.CODE_TYPE = 'SSP_DUTY_CD'
					AND	CD2.CODE = O.DUTY_CD
					AND	CD2.LANG_CD = 'defaultValue'
					AND CD2.COMPANY_SEQ = '3219394'
					 
							JOIN (
								WITH RECURSIVE TEMP AS
								(
									SELECT 	ORG_ID
									FROM 	SSP_REO_ORG
									WHERE 	(UP_ORG_ID = '300001'  OR ORG_ID = '300001')
									AND REO_MANAGE_SEQ = '227630435'
									UNION
									SELECT T.ORG_ID
									FROM	TEMP W
									JOIN  SSP_REO_ORG T
									ON T.UP_ORG_ID = W.ORG_ID
									AND T.REO_MANAGE_SEQ = '227630435'
								)
								SELECT ORG_ID FROM TEMP
							) B
							ON B.ORG_ID = ORG.ORG_ID
						LEFT JOIN (
								WITH RECURSIVE TEMP AS
									(
										SELECT T.ORG_ID, T.UP_ORG_ID,  T.ORG_NM
										FROM (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
												FROM 	SSP_REO_ORG O
												LEFT JOIN SSP_REO_ORG_CHG C
												ON O.ORG_ID = C.ORG_ID
												AND C.REO_MANAGE_SEQ = '227630435'
												WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
												AND C.SEQ IS NULL
												UNION ALL
												SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
												FROM SSP_REO_ORG_CHG O
												WHERE O.REO_MANAGE_SEQ = '227630435') T
										WHERE 	(T.UP_ORG_ID =  '300001' OR T.ORG_ID = '300001')
										UNION
										SELECT T.ORG_ID, T.UP_ORG_ID, T.ORG_NM
										FROM TEMP W
										JOIN (	SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
												FROM 	SSP_REO_ORG O
												LEFT JOIN SSP_REO_ORG_CHG C
												ON O.ORG_ID = C.ORG_ID
												AND C.REO_MANAGE_SEQ = '227630435'
												WHERE O.REO_MANAGE_SEQ = '227630435' -- BASE
												AND C.SEQ IS NULL
												UNION ALL
												SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM
												FROM SSP_REO_ORG_CHG O
												WHERE O.REO_MANAGE_SEQ = '227630435') T
												ON T.UP_ORG_ID = W.ORG_ID
									)
									SELECT ORG_ID FROM TEMP
							) A
							ON A.ORG_ID = ORG.ORG_ID
						 
			WHERE	1=1
			AND 	A.ORG_ID IS NULL
			 
					AND O.REO_MANAGE_SEQ = '227630435';
