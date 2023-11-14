-- By default snapshots of the relevant data are taken every hour and retained for 7 days
exec DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings(
	retention => 10080,		-- Minutes ( = 7 Days). Current value retained if NULL.
	interval => 60			-- Minutes. Current value retained if NULL.
);

-- exec DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings(retention => 691200, interval => 60);