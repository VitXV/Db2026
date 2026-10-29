do $$
	
	-- ддччм - день, часы, десятки минут из даты измерения
	create or replace function calc_ddchchm(dt timestamptz)
	returns text
	language plpgsql
	as $func$
	declare
	    dd int;
	    chch int;
	    m int;
	begin
	    dd := extract(day from dt)::int;
	    chch := extract(hour from dt)::int;
	    m := extract(minute from dt)::int / 10;
	    return lpad(dd::text, 2, '0') || lpad(chch::text, 2, '0') || m::text;
	end;
	$func$;
	
	-- вввв - высота метеопоста (4 цифры с ведущими нулями)
	create or replace function calc_vvvv(height_m numeric)
	returns text
	language plpgsql
	as $func$
	begin
	    return lpad(round(height_m)::text, 4, '0');
	end;
	$func$;
	
	-- бббтт - отклонение давления и температуры
	-- читает табличные значения из таблицы algorithm_constants через get_const()
	create or replace function calc_bbbtt(pressure_mm numeric, temperature_c numeric)
	returns text
	language plpgsql
	as $func$
	declare
	    delta_h int;
	    delta_t int;
	    delta_tv numeric;
	    t0 numeric;
	    bbb text;
	    tt text;
	    points interpolation_points;
	    p_table numeric;
	    t_table numeric;
	begin
	    p_table := get_const('pressure_table');
	    t_table := get_const('temperature_table');
	    
	    points := get_interpolation_points(temperature_c);
	    delta_tv := interpolate(temperature_c, points);
	    
	    t0 := temperature_c + delta_tv;
	    
	    delta_h := round(pressure_mm)::int - round(p_table)::int;
	    if delta_h >= 0 then
	        bbb := lpad(delta_h::text, 3, '0');
	    else
	        bbb := '5' || lpad(abs(delta_h)::text, 2, '0');
	    end if;
	    
	    -- тт: отклонение виртуальной температуры от табличной
	    delta_t := round(t0 - t_table)::int;
	    if delta_t >= 0 then
	        tt := lpad(delta_t::text, 2, '0');
	    else
	        tt := '5' || abs(delta_t)::text;
	    end if;
	    
	    return bbb || tt;
	end;
	$func$;
	
	create or replace function calc_meteo_header(p_log_id int)
	returns text
	language plpgsql
	as $func$
	declare
	    dt timestamptz;
	    height numeric;
	    pressure numeric;
	    temperature numeric;
	begin
	    select l.date_time into dt from logs l where l.id = p_log_id;
	    
	    select
	        max(case when p.type_id = 1 then p.val end),
	        max(case when p.type_id = 2 then p.val end),
	        max(case when p.type_id = 3 then p.val end)
	    into height, temperature, pressure
	    from parameters p
	    where p.log_id = p_log_id;
	    
	    -- формируем заголовок: ддччм вввв бббтт
	    return calc_ddchchm(dt) || ' ' || calc_vvvv(height) || ' ' || calc_bbbtt(pressure, temperature);
	end;
	$func$;

end $$;