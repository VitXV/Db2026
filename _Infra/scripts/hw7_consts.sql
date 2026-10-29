do $$
	-- таблица для хранения констант алгоритма
	create table if not exists algorithm_constants (
	    const_key text primary key,
	    const_value numeric not null,
	    description text
	);
	
	comment on table algorithm_constants is 'константы алгоритма расчета метеобюллетеня';
	comment on column algorithm_constants.const_key is 'ключ константы';
	comment on column algorithm_constants.const_value is 'значение константы';
	comment on column algorithm_constants.description is 'описание константы';
	
	insert into algorithm_constants (const_key, const_value, description) values
	('pressure_table', 750, 'табличное значение давления, мм рт.ст.'),
	('temperature_table', 15.9, 'табличное значение температуры, °c')
	on conflict (const_key) do nothing;
	
	create or replace function get_const(p_key text)
	returns numeric
	language plpgsql
	as $func$
	declare
	    val numeric;
	begin
	    select const_value into val
	    from algorithm_constants
	    where const_key = p_key;
	    
	    if val is null then
	        raise exception 'константа "%" не найдена', p_key;
	    end if;
	    
	    return val;
	end;
	$func$;
end $$;