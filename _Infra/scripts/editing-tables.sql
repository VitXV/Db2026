drop table if exists types_of_parameters;
drop table if exists units;

-- Немного своеобразно получилось.
-- Не вижу смысла создавать ещё одну таблицу с базовыми единицами измерения, если можно хранить их в таблице со всеми типами ед. изм.
-- Соответственно ограничивать минимальное и максимальное значения у типов параметров неправильно. Ведь в других единицах измерения оно может быть вполне себе допустимым.

-- С разными единицами измерения возникают проблемы. Например температура имеет сложную формулу перевода из одних градусов в другие, простым коофицентов тут не обойтись
-- Переводить я не собираюсь, буду просто выводить в нужным единицах измерения

-- слишком много технических нюансов

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


-- Refactoring...
delete from parameters;
delete from logs;

alter table parameters drop column if exists height;
alter table parameters drop column if exists temperature;
alter table parameters drop column if exists preasure;
alter table parameters drop column if exists wind_dir;
alter table parameters drop column if exists wind_speed;

alter table logs drop column if exists par_id;
alter table parameters add column if not exists log_id integer;

alter table logs drop column if exists time_unix;
alter table logs add column if not exists date_time timestamp;

alter table parameters add column if not exists type_id integer not null;
alter table parameters add column if not exists unit_id integer not null;
alter table parameters add column if not exists val numeric not null;

comment on column logs.date_time is 'Время проведения измерений';
comment on column parameters.log_id is 'Идентификатор лога';
comment on column parameters.type_id is 'Идентификатор типа параметров';
comment on column parameters.unit_id is 'Идентификатор единиц измерения';
comment on column parameters.val is 'Значение';

insert into logs (log_id, user_id, date_time) values (1, 2, timestamp '2026-09-27 12:00:00');
insert into logs (log_id, user_id, date_time) values (2, 4, timestamp '2026-09-27 13:00:00');
insert into logs (log_id, user_id, date_time) values (3, 3, timestamp '2026-09-27 14:30:00');

update types_of_equipment set eq_name = 'ДМК' where eq_id = 1;
update types_of_equipment set eq_name = 'ВР' where eq_id = 2;

alter table parameters drop column if exists par_id;

insert into parameters (log_id, eq_id, type_id, unit_id, val) values (1, 1, 1, 1, 540);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (1, 1, 2, 6, 16);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (1, 1, 3, 9, 720);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (1, 1, 4, 13, 16);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (1, 1, 5, 15, 5);

insert into parameters (log_id, eq_id, type_id, unit_id, val) values (2, 1, 1, 1, 140);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (2, 1, 2, 6, 22);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (2, 1, 3, 9, 765);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (2, 1, 4, 13, 0);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (2, 1, 5, 15, 2);

insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 1, 3, 1.2);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 2, 6, 8);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 3, 9, 720);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 4, 13, 45);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 5, 15, 12);
insert into parameters (log_id, eq_id, type_id, unit_id, val) values (3, 2, 6, 15, 10);

-- Мне кажется, я понял что за пачки имелись в виду.
-- Я теперь таблицу параметры использую как пачки.

select parameters.log_id, date_time, firstname, lastname, rank_name, eq_name, type_name, val, short_name
from logs, users, ranks, parameters, types_of_equipment, types_of_parameters, units
where
logs.user_id = users.user_id and
logs.log_id = parameters.log_id and
users.rank_id = ranks.rank_id and
parameters.eq_id = types_of_equipment.eq_id and
parameters.type_id = types_of_parameters.type_id and
parameters.unit_id = units.unit_id
order by parameters.log_id, types_of_parameters.type_id;