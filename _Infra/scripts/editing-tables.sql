drop table if exists types_of_parameters;
drop table if exists units;

-- Не вижу смысла создавать ещё одну таблицу с базовыми единицами измерения, если можно хранить их в таблице со всеми типами ед. изм.
-- Ограничивать минимальное и максимальное значения тоже неправильно. Ведь в других единицах измерения оно может быть вполне себе допустимым

-- Некоторые параметры имеют сложную формулу перевода из одной величины в другую, простым коофицентом тут не обойтись, нужны математические формулы
-- Поэтому переводить их я не собираюсь, буду просто выводить в указанной размерности

create table types_of_parameters
(
type_id integer not null,
type_name text not null
);

comment on table types_of_parameters is 'Типы параметров';
comment on column types_of_parameters.type_id is 'Идентификатор типа параметра';

create table units(
unit_id integer not null,
unit_name text not null,
short_name text not null
);

comment on table units is 'Единицы измерения';
comment on column units.unit_id is 'Идентификатор единицы измерения';
comment on column units.unit_name is 'Название единицы измерения';
comment on column units.short_name is 'Условное обозначение';

insert into types_of_parameters (type_id, type_name) values (1,'Высота');
insert into types_of_parameters (type_id, type_name) values (2,'Температура');
insert into types_of_parameters (type_id, type_name) values (3,'Давление');
insert into types_of_parameters (type_id, type_name) values (4,'Направление ветра');
insert into types_of_parameters (type_id, type_name) values (5,'Скорость ветра');
insert into types_of_parameters (type_id, type_name) values (6,'Дальность сноса пуль');

insert into units (unit_id, unit_name, short_name) values (1, 'Метры', 'м.');
insert into units (unit_id, unit_name, short_name) values (2, 'Сантиметры', 'см.');
insert into units (unit_id, unit_name, short_name) values (3, 'Километры', 'км.');
insert into units (unit_id, unit_name, short_name) values (4, 'Футы', 'фт.');
insert into units (unit_id, unit_name, short_name) values (5, 'Мили', 'миль');

insert into units (unit_id, unit_name, short_name) values (6, 'Градусы Цельсия', 'C');
insert into units (unit_id, unit_name, short_name) values (7, 'Градусы Кельвина', 'K');
insert into units (unit_id, unit_name, short_name) values (8, 'Градусы Фаренгейта', 'F');

insert into units (unit_id, unit_name, short_name) values (9, 'Милиметры ртутного столба', 'мм. рт. ст.');
insert into units (unit_id, unit_name, short_name) values (10, 'Атмосферы', 'атм.');
insert into units (unit_id, unit_name, short_name) values (11, 'Бары', 'бар');
insert into units (unit_id, unit_name, short_name) values (12, 'Паскали', 'Па');

insert into units (unit_id, unit_name, short_name) values (13, 'Больших деления угломера', 'б.д.у.');
insert into units (unit_id, unit_name, short_name) values (14, 'Градусы', 'г.');

insert into units (unit_id, unit_name, short_name) values (15, 'Метры в секунду', 'м/с');
insert into units (unit_id, unit_name, short_name) values (16, 'Километры в час', 'км/ч');
insert into units (unit_id, unit_name, short_name) values (17, 'Футы в секунду', 'фт/с');
insert into units (unit_id, unit_name, short_name) values (18, 'Мили в час', 'мл/ч');

alter table parameters add column if not exists log_id integer;
alter table parameters add column if not exists type_id integer;
alter table parameters add column if not exists unit_id integer;
alter table parameters add column if not exists val numeric;

alter table logs add column if not exists date_time timestamp;

alter table parameters alter column par_id drop not null;
alter table parameters alter column height drop not null;
alter table parameters alter column temperature drop not null;
alter table parameters alter column preasure drop not null;
alter table parameters alter column wind_dir drop not null;
alter table parameters alter column wind_speed drop not null;

update logs set date_time = to_timestamp(time_unix);

update parameters set log_id = logs.log_id from logs where parameters.par_id = logs.par_id;

update parameters set type_id = 1, unit_id = 1, val = height;

insert into parameters (log_id, eq_id, type_id, unit_id, val)
select log_id, eq_id, 2, 6, temperature from parameters where type_id = 1;

insert into parameters (log_id, eq_id, type_id, unit_id, val)
select log_id, eq_id, 3, 9, preasure from parameters where type_id = 1;

insert into parameters (log_id, eq_id, type_id, unit_id, val)
select log_id, eq_id, 4, 13, wind_dir from parameters where type_id = 1;

insert into parameters (log_id, eq_id, type_id, unit_id, val)
select log_id, eq_id, 5, 15, wind_speed from parameters where type_id = 1;

alter table parameters drop column if exists height;
alter table parameters drop column if exists temperature;
alter table parameters drop column if exists preasure;
alter table parameters drop column if exists wind_dir;
alter table parameters drop column if exists wind_speed;
alter table parameters drop column if exists par_id;

alter table logs drop column if exists par_id;
alter table logs drop column if exists time_unix;

alter table parameters alter column log_id set not null;
alter table parameters alter column type_id set not null;
alter table parameters alter column unit_id set not null;
alter table parameters alter column val set not null;

update types_of_equipment set eq_name = 'ДМК' where eq_id = 1;
update types_of_equipment set eq_name = 'ВР' where eq_id = 2;

comment on column logs.date_time is 'Время проведения измерений';
comment on column parameters.log_id is 'Идентификатор лога';
comment on column parameters.type_id is 'Идентификатор типа параметров';
comment on column parameters.unit_id is 'Идентификатор единиц измерения';
comment on column parameters.val is 'Значение';

select date_time, parameters.log_id, firstname, lastname, rank_name, eq_name, type_name, val, short_name
from logs, users, ranks, parameters, types_of_equipment, types_of_parameters, units
where
logs.user_id = users.user_id and
logs.log_id = parameters.log_id and
users.rank_id = ranks.rank_id and
parameters.eq_id = types_of_equipment.eq_id and
parameters.type_id = types_of_parameters.type_id and
parameters.unit_id = units.unit_id
order by parameters.log_id, types_of_parameters.type_id;