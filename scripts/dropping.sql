select 'drop table if exists ' || tablename || ' cascade;' 
from pg_tables 
where schemaname = 'public' 
and tablename not in ('mock_data');