drop table if exists types_of_parameters;
drop table if exists units;

-- Не вижу смысла в создании ещё одной таблицы "Базовые единицы измерения"
-- Вместо этого базовые единицы всегда будут располагаться в таблице "Единицы измерения" под id 1 и с коофицентом 1
-- Хотя может я потом ещё откажусь от этой идеи

create table types_of_parameters
(
type_id integer not null,
type_name text not null,
unit_id integer not null,
min_val integer not null,
max_val integer not null
);

comment on table types_of_parameters is 'Типы параметров';
comment on column types_of_parameters.type_id is 'Идентификатор типа параметра';
comment on column types_of_parameters.unit_id is 'Идентификатор единиц измерения';
comment on column types_of_parameters.type_id is 'Минимальное значение';
comment on column types_of_parameters.type_id is 'Максимальное значение';

create table units(
unit_id integer not null,
unit_name text not null,
coefficient integer not null,
short_name text not null
);

comment on table units is "Единицы измерения"
comment on column units.unit_id is "Идентификатор единицы измерения";
comment on column units.unit_name is "Идентификатор единицы измерения";
comment on column units.coefficient is "Коофицент пересчёта на базовые единицы измерения";
comment on column units.short_name is "Условное обозначение";



select log_id, time_unix, firstname, lastname, rank_name, eq_name, height, temperature, preasure, wind_dir, wind_speed
from logs, users, ranks, parameters, types_of_equipment
where
logs.user_id = users.user_id and
logs.par_id = parameters.par_id and
users.rank_id = ranks.rank_id and
parameters.eq_id = types_of_equipment.eq_id;