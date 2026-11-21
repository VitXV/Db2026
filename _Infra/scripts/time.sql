drop sequence if exists seq_dim_time cascade;

drop table if exists dim_time;

create sequence seq_dim_time;

create table dim_time (
	id int primary key default nextval('seq_dim_time'),
    month_start_date date not null,
    month_end_date date not null,
    month_name varchar(20) not null,
    year smallint not null, 
    quarter_number smallint not null, 
    quarter_name varchar(20) not null
);

comment on table dim_time is 'Измерение времени';

insert into dim_time (
    month_start_date,
    month_end_date,
    month_name,
    year,
    quarter_number,
    quarter_name
)
select
    d::date as month_start_date,
    (d + interval '1 month' - interval '1 day')::date as month_end_date,
    case extract(month from d)::int
        when 1  then 'январь'
        when 2  then 'февраль'
        when 3  then 'март'
        when 4  then 'апрель'
        when 5  then 'май'
        when 6  then 'июнь'
        when 7  then 'июль'
        when 8  then 'август'
        when 9  then 'сентябрь'
        when 10 then 'октябрь'
        when 11 then 'ноябрь'
        when 12 then 'декабрь'
    end as month_name,
    extract(year from d)::smallint as year,
    extract(quarter from d)::smallint as quarter_number,
    'q' || extract(quarter from d)::int as quarter_name
from generate_series(
        date '2020-01-01',
        date '2030-12-01',
        interval '1 month'
     ) as d;

select * from dim_time;