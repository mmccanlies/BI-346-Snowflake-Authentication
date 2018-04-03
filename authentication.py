from query import Query

def queue(archive, start, end):
        q = []
        q.append(Query(1,"""
-- look for any fields not already captured for this entity
insert into raw.etl_messages (pipeline, startDate, message) 
select 'AUTHENTICATION' pipeline, to_timestamp_ntz(current_timestamp) startDate, 'Unknown field ' || n.field || ' found ' || c || ' times' message
from (
    select f.path field, count(*) c
    from raw.authentication_temp t,
    lateral flatten(t.e, recursive=>true) f
    group by f.path
) n
left join (
    select field
    from raw.known_fields k
    where entity = 'AUTHENTICATION'
) k on (n.field = k.field)
where k.field is null
;
"""))
       q.append(Query(2,"""
-- now archive new events to archive
merge into raw.authentication_archive a
using raw.authentication_temp n
ON (a.e = n.e)
when not matched then insert (e) values (n.e)
;
"""))
        q.append(Query(3,"""
-- remove these processed events from pending
delete from raw.authentication_pending a
using raw.authentication_temp n
where n.e = a.e
;
"""))

        return q