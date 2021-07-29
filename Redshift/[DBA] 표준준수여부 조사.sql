--Redshift_테이블컬럼_정보
--테이블 및 컬럼 정보 조회 (코멘트, 데이터타입)
 SELECT
	n.nspname,
	c.relname,
	obj_description(c.oid) as relcomment,
	a.attrelid as "tableoid",
	a.attname as "colname",
	a.attnum as "columnoid",	
	(SELECT col_description(a.attrelid, a.attnum)) as colcomment,
	case when s.udt_name='varchar' then concat(concat(cast(s.udt_name as varchar), '('), concat(cast(s.character_maximum_length as varchar), ')'))
		 when s.udt_name='numeric' then concat(concat(concat(cast(s.udt_name as varchar), '('), concat(cast(s.numeric_precision as varchar), ',')), concat(cast(s.numeric_scale as varchar), ')'))
		else s.udt_name 
	end as std_domain
--	s.data_type,
--	s.udt_name,
--	s.character_maximum_length,
--	s.interval_type
--	s.interval_precision, 
--	s.numeric_precision,
--	s.numeric_scale,
--	s.numeric_precision_radix 
FROM
	pg_catalog.pg_class c
inner join pg_catalog.pg_namespace n on
	c.relnamespace = n.oid
inner join pg_catalog.pg_attribute a on
	a.attrelid = c.oid
left outer join information_schema.columns s on 
	s.column_name = a.attname
	and s.table_name = c.relname
WHERE 1=1
	and c.relkind = 'r'
	and nspname = 'public'
--	and relname = '테이블명'
	and a.attnum > 0
	and a.attisdropped is false
	and pg_catalog.pg_table_is_visible(c.oid)
	;


--테이블 코멘트 조회
 SELECT
	n.nspname,
	c.relname,
	obj_description(c.oid)
FROM
	pg_catalog.pg_class c
inner join pg_catalog.pg_namespace n 
   on c.relnamespace = n.oid
WHERE 1=1
	and c.relkind = 'r'
	and nspname = 'public'
--	and relname = '테이블명'
order by 1,3,2;


	
--컬럼 코멘트 조회
 select
	c.relname,
	a.attrelid as "tableoid",
	a.attname as "colname",
	a.attnum as "columnoid",
	(SELECT col_description(a.attrelid, a.attnum)) AS COMMENT
from
	pg_catalog.pg_class c
inner join pg_catalog.pg_attribute a on
	a.attrelid = c.oid
where
	1=1
--	and c.relname = '테이블명'
	and a.attnum > 0
	and a.attisdropped is false
	and pg_catalog.pg_table_is_visible(c.oid)
order by
	a.attrelid,
	a.attnum
	
--컬럼 조회
 select
	table_name,
	column_name,
	data_type,
	character_maximum_length ,
	character_octet_length ,
	udt_name,
	is_nullable
from
	information_schema.columns
where 1=1
--	and table_name = '테이블명'
order by
	ordinal_position
	
	
	
	
-- REDSHIFT - 임시/백업 명명법에 맞지 않는 테이블 조사
--테이블 코멘트 조회
 SELECT
	n.nspname,
	c.relname,
	obj_description(c.oid)
FROM
	pg_catalog.pg_class c
inner join pg_catalog.pg_namespace n 
   on c.relnamespace = n.oid
WHERE 1=1
	and c.relkind = 'r'
	and nspname = 'public'
UNION
 SELECT
	n.nspname,
	c.relname,
	obj_description(c.oid)
FROM
	pg_catalog.pg_class c
inner join pg_catalog.pg_namespace n 
   on c.relnamespace = n.oid
WHERE 1=1
	and c.relkind = 'r'
	and nspname = 'public'
order by 1,3,2;