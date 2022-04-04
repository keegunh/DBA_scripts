select 
tab.table_schema as database_name, 
tab.table_name 
from 
information_schema.tables tab 
left join information_schema.table_constraints tco on tab.table_schema = tco.table_schema 
and tab.table_name = tco.table_name 
and tco.constraint_type IN ('PRIMARY KEY', 'UNIQUE') 
where tco.constraint_type is null 
and tab.table_schema not in( 
'mysql', 'information_ 
schema', 'performance_schema', 
'sys' 
) 
and tab.table_type = 'BASE TABLE' 
order by 
tab.table_schema, 
tab.table_name; 



show indexes from ERPAPP.CM_APPR_ENTRUST_MST_HIS;
show variables like '%slave_rows_search_algorithms%';