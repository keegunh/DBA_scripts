-- MySQL의 Keyring 플러그인에서 사용되는 키에 대한 정보 확인
SELECT key_id
     , key_owner
     , backend_key_id
  FROM performance_schema.keyring_keys;
