select 'truncate table ' || tablename || ';' 
from pg_tables 
where schemaname = 'public' 
and tablename not in ('mock_data');