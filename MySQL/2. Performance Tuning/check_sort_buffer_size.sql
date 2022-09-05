/*
	Sort_merge_passes : The number of merge passes that the sort algorithm has had to do. 
	If this value is large, you should consider increasing the value of the sort_buffer_size system variable.
	https://dba.stackexchange.com/questions/60078/how-to-determine-the-optimal-sort-buffer-size
*/
SET @SleepTime = 300;
SELECT variable_value INTO @SMP1
FROM performance_schema.global_status WHERE variable_name = 'Sort_merge_passes';
SELECT SLEEP(@SleepTime) INTO @x;
SELECT variable_value INTO @SMP2
FROM performance_schema.global_status WHERE variable_name = 'Sort_merge_passes';
SET @SMP = @SMP2 - @SMP1;
SET @SMP_RATE = @SMP * 3600 / @SleepTime;
SELECT @SMP,@SMP_RATE;


SET GLOBAL sort_buffer_size = 1024 * 1024 * 4;