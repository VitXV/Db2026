-- Удалить ошмётки предыдущих таблиц
begin;

drop table if exists users cascade;
drop table if exists ranks cascade;
drop table if exists equipment cascade;
drop table if exists par_types cascade;
drop table if exists units cascade;
drop table if exists logs cascade;
drop table if exists parameters cascade;
drop table if exists temperature cascade;

drop sequence if exists seq_users cascade;
drop sequence if exists seq_ranks cascade;
drop sequence if exists seq_equipment cascade;
drop sequence if exists seq_par_types cascade;
drop sequence if exists seq_units cascade;
drop sequence if exists seq_logs cascade;
drop sequence if exists seq_parameters cascade;
drop sequence if exists seq_temperature cascade;

commit;

-- Создание таблиц с нуля
begin;

create table users (
id integer not null primary key,
fullname varchar(100) not null,
rank_id integer not null
);

create sequence public.seq_users;
alter table public.users alter column id set default nextval('public.seq_users');

comment on table users is 'Информация о пользователях';
comment on column users.id is 'Идентификатор пользователя';
comment on column users.fullname is 'Имя пользователя';
comment on column users.rank_id is 'Идентификатор должности пользователя';

create table ranks
(
id integer not null primary key,
name varchar(100) not null
);

create sequence public.seq_ranks;
alter table public.ranks alter column id set default nextval('public.seq_ranks');

comment on table ranks is 'Перечень должностей';
comment on column ranks.id is 'Идентификатор должности';
comment on column ranks.name is 'Название должности';

create table equipment
(
id integer not null primary key,
name varchar(20) not null unique
);

create sequence public.seq_equipment;
alter table public.equipment alter column id set default nextval('public.seq_equipment');

comment on table equipment is 'Типы оборудования';
comment on column equipment.id is 'Идентификатор оборудования';
comment on column equipment.name is 'Название оборудования';

create table par_types
(
id integer not null primary key,
name varchar(50) not null unique
);

create sequence public.seq_par_types;
alter table public.par_types alter column id set default nextval('public.seq_par_types');

comment on table par_types is 'Типы параметров';
comment on column par_types.id is 'Идентификатор типа параметра';
comment on column par_types.name is 'Название типа параметра';

create table units(
id integer not null primary key,
name varchar(50) not null,
symbol varchar(15) not null
);

create sequence public.seq_units;
alter table public.units alter column id set default nextval('public.seq_units');

comment on table units is 'Единицы измерения';
comment on column units.id is 'Идентификатор единицы измерения';
comment on column units.name is 'Название единицы измерения';
comment on column units.symbol is 'Условное обозначение';

create table logs (
id integer not null primary key,
user_id integer not null,
eq_id integer not null,
date_time timestamp not null
);

create sequence public.seq_logs;
alter table public.logs alter column id set default nextval('public.seq_logs');

comment on table logs is 'Логи';
comment on column logs.id is 'Идентификатор лога';
comment on column logs.user_id is 'Идентификатор пользователя';
comment on column logs.eq_id is 'Идентификатор оборудования';
comment on column logs.date_time is 'Время проведения измерений';

create table parameters (
id integer not null primary key,
log_id integer not null,
type_id integer not null,
unit_id integer not null,
val decimal not null
);

create sequence public.seq_parameters;
alter table public.parameters alter column id set default nextval('public.seq_parameters');
comment on table parameters is 'Параметры';
comment on column parameters.id is 'Идентификатор параметра';
comment on column parameters.log_id is 'Идентификатор лога';
comment on column parameters.type_id is 'Идентификатор типа параметров';
comment on column parameters.unit_id is 'Идентификатор единиц измерения';
comment on column parameters.val is 'Значение';

create table temperature (
id integer not null primary key,
name varchar (25) not null unique,
coof decimal not null,
corr decimal not null
);

create sequence public.seq_temperature;
alter table public.temperature alter column id set default nextval('public.seq_temperature');

comment on table temperature is 'Расчёт температуры';
comment on column temperature.id is 'Идентификатор расчёта температуры';
comment on column temperature.name is 'Название формулы';
comment on column temperature.coof is 'Коофицент перевода';
comment on column temperature.corr is 'Добавление';

commit;

-- Заполнить таблицы
begin;

insert into ranks (id, name) values 
(1, 'Лейтенант'),
(2, 'Сержант'),
(3, 'Рядовой');

insert into users (id, fullname, rank_id) values 
(1, 'Александр Адамов', 1),
(2, 'Борис Баренцев', 2),
(3, 'Владимир Володин', 3),
(4, 'Геннадий Горный', 3);

insert into equipment (id, name) values 
(1, 'ДМК'),
(2, 'ВР');

insert into par_types (id, name) values 
(1, 'Высота'),
(2, 'Температура'),
(3, 'Давление'),
(4, 'Направление ветра'),
(5, 'Скорость ветра'),
(6, 'Дальность сноса пуль');

insert into units (id, name, symbol) values 
(1, 'Метры', 'м.'),
(2, 'Сантиметры', 'см.'),
(3, 'Километры', 'км.'),
(4, 'Футы', 'фт.'),
(5, 'Мили', 'миль');

insert into units (id, name, symbol) values 
(6, 'Градусы Цельсия', 'C'),
(7, 'Градусы Кельвина', 'K'),
(8, 'Градусы Фаренгейта', 'F');

insert into units (id, name, symbol) values 
(9, 'Милиметры ртутного столба', 'мм. рт. ст.'),
(10, 'Атмосферы', 'атм.'),
(11, 'Бары', 'бар'),
(12, 'Паскали', 'Па');

insert into units (id, name, symbol) values 
(13, 'Большие деления угломера', 'б.д.у.'),
(14, 'Градусы', 'г.');

insert into units (id, name, symbol) values 
(15, 'Метры в секунду', 'м/с'),
(16, 'Километры в час', 'км/ч'),
(17, 'Футы в секунду', 'фт/с'),
(18, 'Мили в час', 'мл/ч');

insert into logs (id, user_id, eq_id, date_time) values 
(1, 2, 1, to_timestamp(1789904391)),
(2, 4, 2, to_timestamp(1789904091)),
(3, 3, 1, to_timestamp(1789900391));

insert into parameters (id, log_id, type_id, unit_id, val) values 
(1,  1, 1, 1, 540),
(2,  1, 2, 6, 16),
(3,  1, 3, 9, 720),
(4,  1, 4, 13, 16),
(5,  1, 5, 15, 5);

insert into parameters (id, log_id, type_id, unit_id, val) values 
(6,  2, 1, 1, 1200),
(7,  2, 2, 6, 8),
(8,  2, 3, 9, 720),
(9,  2, 4, 13, 45),
(10, 2, 5, 15, 12);

insert into parameters (id, log_id, type_id, unit_id, val) values 
(11, 3, 1, 1, 140),
(12, 3, 2, 6, 22),
(13, 3, 3, 9, 765),
(14, 3, 4, 13, 0),
(15, 3, 5, 15, 2);

insert into temperature (id, name, coof, corr) values 
(1, 'Цельсий в Фаренгейт', 1.8, 32),
(2, 'Цельсий в Кельвин', 1.0, 273.15),
(3, 'Фаренгейт в Цельсий', 1.0/1.8, -32.0/1.8),
(4, 'Кельвин в Цельсий', 1.0/1.0, -273.15),
(5, 'Фаренгейт в Кельвин', 5.0/9.0, 255.3722),
(6, 'Кельвин в Фаренгейт', 1.8, -459.67);

commit;


-- Создание связей
begin;

alter table users 
add constraint fk_users_rank 
foreign key (rank_id) references ranks(id);

alter table logs 
add constraint fk_logs_user 
foreign key (user_id) references users(id);

alter table logs 
add constraint fk_logs_eq 
foreign key (eq_id) references equipment(id);

alter table parameters 
add constraint fk_params_log 
foreign key (log_id) references logs(id);

alter table parameters 
add constraint fk_params_type 
foreign key (type_id) references par_types(id);

alter table parameters 
add constraint fk_params_unit 
foreign key (unit_id) references units(id);

commit;