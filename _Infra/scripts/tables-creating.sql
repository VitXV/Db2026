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

comment on table users is 'Информация о пользователях';
comment on column users.user_id is 'Идентификатор пользователя';
comment on column users.firstname is 'Имя пользователя';
comment on column users.lastname is 'Фамилия пользователя';
comment on column users.rank_id is 'Идентификатор должности пользователя';

create table ranks
(
rank_id integer not null,
rank_name text not null
);

comment on table ranks is 'Перечень должностей';
comment on column ranks.rank_id is 'Идентификатор должности';
comment on column ranks.rank_name is 'Название должности';

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

comment on table parameters is 'Параметры';
comment on column parameters.par_id is 'Идентификатор параметров';
comment on column parameters.eq_id is 'Идентификатор измерительного оборудования';
comment on column parameters.height is 'Высота (м. над уровнем моря)';
comment on column parameters.temperature is 'Температура (гр. Цельсия)';
comment on column parameters.preasure is 'Давление (мм. рт. ст.)';
comment on column parameters.wind_dir is 'Направление ветра (б. д. у.)';
comment on column parameters.wind_speed is 'Скорость ветра (м/с)';

create table types_of_equipment
(
eq_id integer not null,
eq_name text not null
);

comment on table types_of_equipment is 'Типы оборудования';
comment on column types_of_equipment.eq_id is 'Идентификатор оборудования';
comment on column types_of_equipment.eq_name is 'Название оборудования';

create table logs
(
log_id integer not null,
user_id integer not null,
par_id integer not null,
time_unix integer not null
);

comment on table logs is 'Логи';
comment on column logs.log_id is 'Идентификатор лога';
comment on column logs.user_id is 'Идентификатор пользователя';
comment on column logs.par_id is 'Идентификатор параметров';
comment on column logs.time_unix is 'Время проведения измерений (формат unix)';

insert into users (user_id, firstname, lastname, rank_id) values (1, 'Адамов','Александр',1);
insert into users (user_id, firstname, lastname, rank_id) values (2, 'Баренцев','Борис',2);
insert into users (user_id, firstname, lastname, rank_id) values (3, 'Володин','Владимир',3);
insert into users (user_id, firstname, lastname, rank_id) values (4, 'Горный','Геннадий',3);

insert into ranks (rank_id, rank_name) values (1,'Лейтенант');
insert into ranks (rank_id, rank_name) values (2,'Сержант');
insert into ranks (rank_id, rank_name) values (3,'Рядовой');

insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (1, 1, 540, 16, 720, 16, 5);
insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (2, 1, 140, 22, 765, 0, 2);
insert into parameters (par_id, eq_id, height, temperature, preasure, wind_dir, wind_speed) values (3, 2, 1200, 8, 720, 45, 12);
	
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