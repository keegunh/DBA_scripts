---------- sqlplus new_value TEST ----------------
col cpu_count_val new_value cpu_count noprint
select value cpu_count_val
from v$parameter
where name like '%cpu_count%';

select 'The current cpu count is '||'&&cpu_count' from dual;

select 'test' as cpu_count_val from dual;
select '&&cpu_count' from dual;

column today  new_value  today;
select to_char(sysdate,'mm/dd/yyyy hh24:mi') today
from dual;