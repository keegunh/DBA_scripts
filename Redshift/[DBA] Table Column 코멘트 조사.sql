  SELECT
    col.table_schema
,   col.table_name
,   tbl.description     as table_comment
,   col.ordinal_position
,   col.column_name
,   pgd.description     as column_comment
,   col.data_type	
-- ,   col.column_default
,   col.is_nullable
,   case when col.character_maximum_length is null then col.numeric_precision else col.character_maximum_length end
-- ,   col.numeric_precision_radix
-- ,   col.numeric_scale
,   pkey_yn.yn -- pk 여부 추가
FROM
    pg_catalog.pg_statio_all_tables     sat
    INNER JOIN
        pg_catalog.pg_description       pgd
    ON  (
            pgd.objoid          = sat.relid
        )
    INNER JOIN
        pg_catalog.pg_description       tbl
    ON  (
            tbl.objoid          = pgd.objoid
        AND tbl.objsubid        = 0
    )
    INNER JOIN
        information_schema.columns  col
    ON  (
            col.ordinal_position= pgd.objsubid
        AND col.table_schema    = sat.schemaname
        AND col.table_name      = sat.relname
        )
    -- pk 여부 추가
    left join
	(select table_name, column_name, 'Y' as yn from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where table_schema='lpowr' and constraint_name like 'pk_%') pkey_yn
	on ( pkey_yn.table_name = col.table_name and pkey_yn.column_name = col.column_name)
WHERE 1 = 1
-- AND col.table_name          = 'tb_faq'
--AND col.table_schema          = 'lpowr'
ORDER BY
    col.table_schema
    ,col.table_name
    ,col.ordinal_position