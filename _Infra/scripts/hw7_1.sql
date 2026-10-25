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
	
	-- функция для проверки корректности параметров
	create or replace function validate_parameter_pack(pack parameter_pack)
	returns text
	language plpgsql
	as $func$
	declare
	    errors text := '';
	    eq_upper text;
	    lim record;
	    param_val numeric;
	    param_name text;
	begin
	    eq_upper := upper(pack.equipment_code);
	
	    if eq_upper not in ('ДМК', 'ВР') then
	        errors := errors || 'неверный тип оборудования: ' || pack.equipment_code || '; ';
	    end if;
	
	    for lim in 
	        select pl.*, pt.name 
	        from param_limits pl
	        join par_types pt on pl.type_id = pt.id
	        order by pl.type_id
	    loop
	        case lim.type_id
	            when 1 then 
	                param_val := pack.height;
	                param_name := 'высота';
	            when 2 then 
	                param_val := pack.temperature;
	                param_name := 'температура';
	            when 3 then 
	                param_val := pack.pressure;
	                param_name := 'давление';
	            when 4 then 
	                param_val := pack.wind_dir;
	                param_name := 'направление ветра';
	            when 5 then 
	                param_val := pack.wind_speed;
	                param_name := 'скорость ветра';
	            when 6 then 
	                param_val := pack.bullet_drift;
	                param_name := 'дальность сноса пуль';
	        end case;
	
	        -- проверка обязательности для типа оборудования
	        if eq_upper = 'ДМК' and lim.is_required_for_dmk = false then
	            if param_val is not null then
	                errors := errors || param_name || ' не используется для ДМК; ';
	            end if;
	        elsif eq_upper = 'ВР' and lim.is_required_for_vr = false then
	            if param_val is not null then
	                errors := errors || param_name || ' не используется для вр; ';
	            end if;
	        else
	            -- параметр используется, проверяем наличие и границы
	            if param_val is null then
	                errors := errors || param_name || ' не указана; ';
	            elsif param_val < lim.min_val or param_val > lim.max_val then
	                errors := errors || param_name || ' вне диапазона [' || lim.min_val || ', ' || lim.max_val || ']: ' || param_val || '; ';
	            end if;
	        end if;
	    end loop;
	
	    if errors <> '' then
	        errors := rtrim(errors, '; ');
	    end if;
	
	    return errors;
	end;
	$func$;

end $$;