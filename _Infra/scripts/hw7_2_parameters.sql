do $$
	with packs as (
	    select
	        l.id as log_id,
	        l.user_id,
	        e.name as equipment_name,
	        max(case when p.type_id = 1 then p.val end) as height,
	        max(case when p.type_id = 2 then p.val end) as temperature,
	        max(case when p.type_id = 3 then p.val end) as pressure,
	        max(case when p.type_id = 4 then p.val end) as wind_dir,
	        max(case when p.type_id = 5 and e.name = 'ДМК' then p.val end) as wind_speed,
	        max(case when p.type_id = 6 and e.name = 'ВР' then p.val end) as bullet_drift
	    from logs l
	    join parameters p on p.log_id = l.id
	    join equipment e on e.id = l.eq_id
	    group by l.id, l.user_id, e.name
	),
	validation as (
	    select
	        log_id,
	        user_id,
	        equipment_name,
	        height,
	        temperature,
	        pressure,
	        wind_dir,
	        wind_speed,
	        bullet_drift,
	        validate_parameter_pack((
	            equipment_name,
	            height,
	            temperature,
	            pressure,
	            wind_dir,
	            wind_speed,
	            bullet_drift
	        )::parameter_pack) as error_description
	    from packs
	)
	select
	    row_number() over (order by log_id) as "№",
	    equipment_name as "Тип оборудования",
	    height as "Высота метеопоста",
	    temperature as "Температура",
	    pressure as "Давление",
	    wind_dir as "Направление ветра",
	    wind_speed as "Скорость ветра",
	    bullet_drift as "Дальность сноса пуль",
	    (error_description <> '') as "Есть ошибка",
	    nullif(error_description, '') as "Описание ошибки"
	from validation
	order by log_id;
end $$;