declare @db int
select @db=DB_ID('NBMDB')

-- 인덱스 fragmention 정도 확인
select 'ALTER INDEX [' + i.name +'] on '+OBJECT_NAME(s.object_id)+' REBUILD WITH (ONLINE = ON)' REBUILD_DDL,
objname = OBJECT_NAME(s.object_id),
s.object_id,
index_name= i.name,
index_type_desc, 
avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats(@db,null,null,null,null) as s
join sys.indexes i on i.object_id = s.object_id and i.index_id = s.index_id 
where avg_fragmentation_in_percent>30
order by avg_fragmentation_in_percent desc, page_count desc;


-- 인덱스 통계 조회
select objname = OBJECT_NAME(s.object_id),
s.object_id,
index_name= i.name,
index_id = i.index_id,
user_seeks, user_scans, user_lookups
from sys.dm_db_index_usage_stats as s
join sys.indexes i on i.object_id = s.object_id and i.index_id = s.index_id
where database_id = DB_ID('NBMDB')
and OBJECTPROPERTY(s.object_id,'IsUserTable')=1
order by (user_seeks + user_scans + user_lookups) desc;