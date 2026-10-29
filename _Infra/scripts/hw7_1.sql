do $$
	alter table parameters add column if not exists is_valid boolean default true;
	alter table parameters add column if not exists error_description text;
	
	comment on column parameters.is_valid is 'Корректность значения параметра';
	comment on column parameters.error_description is 'Текст ошибки валидации';
	
	create table if not exists param_limits (
	    type_id integer not null primary key,
	    min_val numeric not null,
	    max_val numeric not null,
	    is_required_for_dmk boolean default false,
	    is_required_for_vr boolean default false,
	    description text
	);
	
	comment on table param_limits is 'граничные условия для валидации параметров';
	comment on column param_limits.type_id is 'идентификатор типа параметра';
	comment on column param_limits.min_val is 'минимальное допустимое значение';
	comment on column param_limits.max_val is 'максимальное допустимое значение';
	comment on column param_limits.is_required_for_dmk is 'обязателен для дмк';
	comment on column param_limits.is_required_for_vr is 'обязателен для вр';
	
	insert into param_limits (type_id, min_val, max_val, is_required_for_dmk, is_required_for_vr, description) values
	(1, -1000, 15000, true, true, 'высота метеопоста, м'),
	(2, -58, 58, true, true, 'температура, °c'),
	(3, 500, 900, true, true, 'давление, мм рт.ст.'),
	(4, 0, 59, true, true, 'направление ветра, б.д.у.'),
	(5, 0, 15, true, false, 'скорость ветра, м/с (только дмк)'),
	(6, 0, 150, false, true, 'дальность сноса пуль, м (только вр)')
	on conflict (type_id) do nothing;

	-- таблица для хранения текстов ошибок (настроечная)
	create table if not exists error_messages (
	    error_code text primary key,
	    error_text text not null
	);
	
	comment on table error_messages is 'настроечная таблица текстов ошибок валидации';

	insert into error_messages (error_code, error_text) values
	('invalid_equipment',     'неверный тип оборудования: '),
	('param_not_specified',   ' не указана'),
	('param_out_of_range',    ' вне диапазона ['),
	('param_not_used_dmk',    ' не используется для ДМК'),
	('param_not_used_vr',     ' не используется для ВР')
	on conflict (error_code) do nothing;
	
	drop type if exists parameter_pack cascade;
	create type parameter_pack as (
	    equipment_code text,
	    height numeric,            -- высота метеопоста
	    temperature numeric,       -- температура
	    pressure numeric,          -- давление
	    wind_dir numeric,          -- направление ветра
	    wind_speed numeric,        -- скорость ветра
	    bullet_drift numeric       -- дальность сноса пуль
	);
	
	-- функция проверки корректности параметров
	create or replace function validate_parameter_pack(pack parameter_pack)
	returns text
	language sql
	as $func$
	    with 
	    param_values as (
	        select 
	            pl.type_id,
	            pl.min_val,
	            pl.max_val,
	            pl.is_required_for_dmk,
	            pl.is_required_for_vr,
	            pt.name as param_name,
	            case pl.type_id
	                when 1 then pack.height
	                when 2 then pack.temperature
	                when 3 then pack.pressure
	                when 4 then pack.wind_dir
	                when 5 then pack.wind_speed
	                when 6 then pack.bullet_drift
	            end as param_val
	        from param_limits pl
	        join par_types pt on pl.type_id = pt.id
	    ),
	    errors as (
	        -- проверка типа оборудования
	        select 
	            0 as ord,
	            (select error_text from error_messages where error_code = 'invalid_equipment')
	            || pack.equipment_code as msg
	        where upper(pack.equipment_code) not in ('ДМК', 'ВР')
	        
	        union all
	        
	        -- проверки по каждому параметру
	        select 
	            pv.type_id as ord,
	            case
	                -- параметр не используется для данного типа оборудования, но передан
	                when upper(pack.equipment_code) = 'ДМК' 
	                     and not pv.is_required_for_dmk 
	                     and pv.param_val is not null
	                then pv.param_name || (select error_text from error_messages where error_code = 'param_not_used_dmk')
	                
	                when upper(pack.equipment_code) = 'ВР' 
	                     and not pv.is_required_for_vr 
	                     and pv.param_val is not null
	                then pv.param_name || (select error_text from error_messages where error_code = 'param_not_used_vr')
	                
	                -- параметр не указан
	                when pv.param_val is null
	                then pv.param_name || (select error_text from error_messages where error_code = 'param_not_specified')
	                
	                -- параметр вне диапазона
	                when pv.param_val < pv.min_val or pv.param_val > pv.max_val
	                then pv.param_name 
	                     || (select error_text from error_messages where error_code = 'param_out_of_range')
	                     || pv.min_val || ', ' || pv.max_val || ']: ' || pv.param_val::text
	            end as msg
	        from param_values pv
	    )
	    select coalesce(string_agg(msg, '; ' order by ord), '')
	    from errors
	    where msg is not null;
	$func$;

end $$;