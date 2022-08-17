select (@@innodb_buffer_pool_size
     + @@key_buffer_size
     + ((@@read_buffer_size + @@read_rnd_buffer_size + @@sort_buffer_size + @@join_buffer_size) * @@max_connections)
     ) / pow(1024,3) as total_memory_GiB; 
-- Maximum MySQL Memory Usage = innodb_buffer_pool_size + key_buffer_size + ((read_buffer_size + read_rnd_buffer_size + sort_buffer_size + join_buffer_size) X max_connections)

select @@innodb_buffer_pool_size / pow(1024,3); -- 93GiB
select @@key_buffer_size/1024/1024; -- 8MiB
select @@read_buffer_size /1024/1024; -- 1MiB
select @@read_rnd_buffer_size/1024/1024; -- 1MiB
select @@sort_buffer_size/1024/1024; -- 20MiB
select @@join_buffer_size/1024/1024; -- 5MiB
select @@max_connections; -- 2000


select @@innodb_page_size/1024; -- 16KiB
select @@innodb_buffer_pool_size/1024/1024/1024; -- 93GiB
select @@innodb_log_buffer_size/1024/1024; -- 16MiB
select @@innodb_log_file_size/1024/1024; -- 512MiB
select @@innodb_log_files_in_group; -- 2
select @@innodb_log_write_ahead_size/1024; -- 8KiB
select @@key_buffer_size/1024/1024; -- 8MiB
select @@read_buffer_size /1024/1024; -- 1MiB
select @@read_rnd_buffer_size/1024/1024; -- 1MiB
select @@sort_buffer_size/1024/1024; -- 20MiB
select @@join_buffer_size/1024/1024; -- 5MiB
select @@max_connections; -- 2000