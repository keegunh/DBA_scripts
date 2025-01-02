-- Find Current Schema
select current_Schema();

-- Current User
select current_user;

-- Current Database
select current_database();

-- Current setting of any parameter in PostgreSQL
select current_setting('max_parallel_workers');

-- Current User process id
select pg_backend_pid();

-- Find Postmaster start time (When the DB instance started)
select pg_postmaster_start_time();

-- PostgreSQL Version
select version ();

-- Backup is running or not
select pg_is_in_backup();

-- Date & Time in PostgreSQL with time zone:
select now () as current;

-- Current Date and Time without Timezone
SELECT NOW ()::timestamp;

-- Add 1 hour to existing date and time
SELECT (NOW () + interval '1 hour') AS an_hour_later;

-- To Find next day date and time 
SELECT (NOW () + interval '1 day') AS this_time_tomorrow;

-- To deduct 2 hours and 30 minutes from current time
SELECT now() - interval '2 hours 30 minutes' AS two_hour_30_min_go;