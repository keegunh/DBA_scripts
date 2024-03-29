			SELECT 	O.ORG_ID, O.UP_ORG_ID, O.ORG_NM, O.ORG_TYPE_CD, O.REO_MANAGE_SEQ
					FROM 	SSP_REO_ORG O
					LEFT JOIN SSP_REO_ORG_CHG C
					ON O.ORG_ID = C.ORG_ID
					AND C.REO_MANAGE_SEQ = '432425126'
					WHERE O.REO_MANAGE_SEQ = @BASE_REO_SEQ -- BASE
					AND C.SEQ IS NULL
					UNION ALL
					SELECT O.ORG_ID, O.UP_ORG_ID, O.ORG_NM, O.ORG_TYPE_CD, O.REO_MANAGE_SEQ
					FROM SSP_REO_ORG_CHG O
					WHERE O.REO_MANAGE_SEQ = '432425126'
			) O
			LEFT JOIN (
			SELECT 	O.PERSON_ID, O.DUTY_CD, O.ORG_ID, O.DUAL_YN
						FROM 	SSP_REO_EMP O
						LEFT JOIN SSP_REO_EMP_CHG C
						ON O.EMP_ID = C.EMP_ID
						AND C.REO_MANAGE_SEQ = '432425126'
						WHERE O.REO_MANAGE_SEQ = @BASE_REO_SEQ -- BASE
						AND C.SEQ IS NULL AND O.LEADER_YN ='Y'
						UNION ALL
						SELECT	O.PERSON_ID, O.DUTY_CD, O.ORG_ID, O.DUAL_YN
						FROM SSP_REO_EMP_CHG O
						WHERE O.REO_MANAGE_SEQ = '432425126'  AND O.LEADER_YN ='Y'
			) E
			ON E.ORG_ID = O.ORG_ID
			LEFT JOIN (
				SELECT 	O.PERSON_ID, O.DUTY_CD, O.ORG_ID, O.DUAL_YN
						FROM 	SSP_REO_EMP O
