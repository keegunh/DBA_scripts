-- MySQL 서버가 구동된 시점부터 현재까지 사용되지 않은 DB 계정들을 확인
-- 현재 MySQL에 생성돼 있는 계정들을 대상으로 계정별 접속 이력 유무와 뷰, 또는 트리거, 스토어드 프로시저 같은 스토어드 프로그램들의 생성 유무를 확인해서 
-- 두 경우 모두에 해당되지 않는 계정들의 목록 출력
SELECT DISTINCT m_u.user, m_u.host
  FROM mysql.user m_u
  LEFT JOIN performance_schema.accounts ps_a 
    ON m_u.user = ps_a.user
   AND m_u.host = ps_a.host
  LEFT JOIN information_schema.views is_v
    ON is_v.definer = CONCAT(m_u.user, '@', m_u.host)
   AND is_v.security_type = 'DEFINER'
  LEFT JOIN information_schema.routines is_r
    ON is_r.definer = CONCAT(m_u.user, '@', m_u.host)
   AND is_r.security_type = 'DEFINER'
  LEFT JOIN information_schema.events is_e
    ON is_e.definer = CONCAT(m_u.user, '@', m_u.host)
  LEFT JOIN information_schema.triggers is_t
    ON is_t.definer = CONCAT(m_u.user, '@', m_u.host)
 WHERE ps_a.user IS NULL
   AND is_v.definer IS NULL
   AND is_r.definer IS NULL
   AND is_e.definer IS NULL
   AND is_t.definer IS NULL
  ORDER BY m_u.user, m_u.host;