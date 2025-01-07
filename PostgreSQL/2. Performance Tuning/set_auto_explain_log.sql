LOAD 'auto_explain';
SET auto_explain.log_min_duration=0;
SET auto_explain.log_analyze=true;
select * from test1 where cust_id=$1 \bind '33423' \g