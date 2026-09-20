drop table if exists users;
drop table if exists ranks;
drop table if exists parameters;
drop table if exists types_of_equipment;
drop table if exists logs;

create table users
(
user_id integer not null,
firstname text not null,
lastname text not null,
rank_id integer not null
);

create table ranks
(
rank_id integer not null,
rank_name text not null
);

create table parameters
(
par_id integer not null,
eq_id integer not null,
height integer not null,
temperature integer not null,
preasure integer not null,
wind_dir integer not null,
wind_speed integer not null
);

create table types_of_equipment
(
eq_id integer not null,
eq_name text not null
);

create table logs
(
log_id integer not null,
user_id integer not null,
par_id integer not null,
time_unix integer not null
);

insert into users (user_id, firstname, lastname, rank_id) values (1, 'Адамов','Александр',1);
insert into users (user_id, firstname, lastname, rank_id) values (2, 'Баренцев','Борис',2);
insert into users (user_id, firstname, lastname, rank_id) values (3, 'Володин','Владимир',3);
insert into users (user_id, firstname, lastname, rank_id) values (4, 'Горный','Геннадий',3);

insert into ranks (rank_id, rank_name) values (1,'Лейтенант');
insert into ranks (rank_id, rank_name) values (2,'Сержант');
insert into ranks (rank_id, rank_name) values (3,'Рядовой');

insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (1, 1, 540, 16, 720, 60, 5);
insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (2, 1, 140, 22, 765, 0, 2);
insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (3, 2, 1200, 8, 720, 145, 15);
	
insert into types_of_equipment(eq_id, eq_name) values (1,'Устройство 1');
insert into types_of_equipment(eq_id, eq_name) values (2,'Устройство 2');

insert into logs (log_id, user_id, par_id, time_unix) values (1,2,1,1789904391);
insert into logs (log_id, user_id, par_id, time_unix) values (2,4,3,1789904091);
insert into logs (log_id, user_id, par_id, time_unix) values (3,3,2,1789900391);

select log_id, time_unix, firstname, lastname, rank_name, eq_name, height, temperature, preasure, wind_dir, wind_speed
from logs, users, ranks, parameters, types_of_equipment
where
logs.user_id = users.user_id and
logs.par_id = parameters.par_id and
users.rank_id = ranks.rank_id and
parameters.eq_id = types_of_equipment.eq_id;