CREATE TABLE vacuum_test (
    integer_column integer
);


SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );


SELECT pg_size_pretty(
           pg_database_size('analysis')
       );



INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);


SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );


UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Test its size again (35 MB)
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );


SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';


SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';


VACUUM vacuum_test;

VACUUM; -- vacuums the whole database

VACUUM VERBOSE; -- provides messages


VACUUM FULL vacuum_test;

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );


SHOW config_file;

SHOW data_directory;


pg_dump -d analysis -U [user_name] -Fc > analysis_backup.sql


pg_dump -t 'train_rides' -d analysis -U [user_name] -Fc > train_backup.sql


pg_restore -C -d postgres -U postgres analysis_backup_custom.sql