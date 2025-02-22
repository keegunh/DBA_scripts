Extended Statistics



1)	CREATE TABLE data_stats(a int, b int);

2) INSERT INTO data_stats SELECT x/100, x/1000 FROM generate_series(1,1000000) g(x);

3) ANALYZE VERBOSE data_stats;
4) set max_parallel_workers_per_gather =0;
5) Explain analyze select * from data_stats where a=1;
6) Explain analyze select * from data_stats where a=1 and b=0;

7) Create statistics data_stats_ext(dependencies) on a,b from data_stats;

8) Analyze VERBOSE data_stats;

9) Explain analyze select * from data_stats where a=1 and b=0;


