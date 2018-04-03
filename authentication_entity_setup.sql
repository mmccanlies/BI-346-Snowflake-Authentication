 use role accountadmin;
go
use warehouse ENG_WH;
go
use database LIFESIZE_DB;
go
use schema raw;
go
create table if not exists raw.known_fields (entity string, field string, constraint known_fields_pk PRIMARY KEY (entity, field))
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'userAccountID')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'userID')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'groupID')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'guest')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'errorCode')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'errorReasonCode')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.userLogin')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.version')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.IP')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.platform')
go
insert into raw.known_fields (entity, field) values ('AUTHENTICATION', 'requestInfo.userAgent')
go
create table if not exists authentications_history  ( 
	id              	varchar(255) not null,
	eventDate       	bigint(20) not null,
	domainName         	varchar(255) not null,
	eventSource     	varchar(255) null,
	eventType       	varchar(255) not null,
	eventVersion    	int(11) null,
	eventYear       	smallint(6) not null,
	eventMonth      	tinyint(4) not null,
	authenticationId	varchar(255) null,
	userAccountId   	varchar(255) null,
	userId          	varchar(255) null,
	groupId         	varchar(255) null,
	devicePairingId 	varchar(255) null,
	guest           	tinyint(1) null,
	userLogin       	varchar(255) null,
	pairingToken    	varchar(255) null,
	serialNumber    	varchar(255) null,
	platform        	varchar(255) null,
	version         	varchar(255) null,
	ip              	varchar(255) null,
	userAgent       	varchar(255) null,
	errorCode       	int(11) null,
	errorReasonCode 	varchar(255) null,
    constraint authentication_history_pk PRIMARY KEY(domainName,id,eventType,eventDate,eventYear,eventMonth)
)
go
select distinct f.path
from (select * from raw.events where e:eventType::STRING like 'AUTHENTICATION_%') t,
lateral flatten(t.e, recursive=>true) f
go
select field from raw.known_fields where entity = 'AUTHENTICATION'
go

