select table_name, 'таблица' as object_name from information_schema.tables
where table_schema = 'public'
union all
select sequence_name, 'последовательность' as object_type from information_schema.sequences
where sequence_schema = 'public'