-- очистка дубликатов, если предыдущицй скрипт запускался дважды
delete from calc_correction_heights
where id not in (select min(id) from calc_correction_heights group by height);

delete from calc_correction_types where id > 9;

delete from calc_correction
where id not in (select min(id) from calc_correction group by height_id, type_id);

-- добавляю конастанты в уже существующую таблицу

insert into algorithm_constants (const_key, const_value, description)
values
('min_wind_speed', 3, 'Минимальная скорость ветра для ДМК, м/с (при меньших значениях скорость ветра = 0)'),
('negative_temp_offset', 50, 'Добавка к модулю отклонения температуры для отрицательных значений'),
('min_spread', 40, 'Минимальная дальность сноса пуль для ВР, м (при меньших значениях скорость ветра = 0)')
on conflict (const_key) do nothing;

-- составной тип для параметров
do $$
begin
    if not exists (select 1 from pg_type where typname = 'lst_parameter') then
        create type public.lst_parameter as (
            id_pack integer,
            id_type_parameter integer,
            param_value numeric
        );
    end if;
end $$;

create or replace function public.get_temperature_interpolation(par_temperature numeric)
returns numeric
language plpgsql
as $body$
declare
    var_points interpolation_points;
begin
    var_points := public.get_interpolation_points(par_temperature);
    return public.interpolate(par_temperature, var_points);
end;
$body$;

do $$
begin
    drop procedure if exists public.calculate_meteo_bulletin_proc(public.lst_parameter[], integer);
    
    create or replace procedure public.calculate_meteo_bulletin_proc(
        p_params public.lst_parameter[],
        p_equip_id integer
    )
    language plpgsql
    as $body$
    declare
        v_press numeric;
        v_temp numeric;
        v_wind_dir numeric;
        v_wind_speed numeric;
        v_spread numeric;
        v_const_p numeric;
        v_const_t numeric;
        v_min_spread numeric;
        v_min_wind_speed numeric;
        v_negative_offset numeric;
        v_delta_h integer;
        v_delta_tv numeric;
        v_t0_virt numeric;
        v_delta_t0 integer;
    begin
        select param_value into v_temp from unnest(p_params) where id_type_parameter = 2;
        select param_value into v_press from unnest(p_params) where id_type_parameter = 3;
        select param_value into v_wind_dir from unnest(p_params) where id_type_parameter = 4;
        select param_value into v_wind_speed from unnest(p_params) where id_type_parameter = 5;
        select param_value into v_spread from unnest(p_params) where id_type_parameter = 6;
        
        -- Константы из таблицы algorithm_constants
        select const_value into v_const_p from algorithm_constants where const_key = 'pressure_table';
        select const_value into v_const_t from algorithm_constants where const_key = 'temperature_table';
        select const_value into v_min_spread from algorithm_constants where const_key = 'min_spread';
        select const_value into v_min_wind_speed from algorithm_constants where const_key = 'min_wind_speed';
        select const_value into v_negative_offset from algorithm_constants where const_key = 'negative_temp_offset';
        
        -- Расчёты
        v_delta_h := round(v_press - v_const_p)::integer;
        v_delta_tv := public.get_temperature_interpolation(v_temp);
        v_t0_virt := v_temp + v_delta_tv;
        v_delta_t0 := round(v_t0_virt - v_const_t)::integer;
        
        drop table if exists tmp_bulletin;
        
        create temp table tmp_bulletin (
            h integer,
            tt integer,
            hh integer,
            cc integer
        );
        
        insert into tmp_bulletin
        select
            h.height as h,
            case when v_delta_t0 < 0 then
              v_negative_offset + abs(
                coalesce(cc9.row_values[array_position(ct9.header_values, (abs(v_delta_t0) / 10) * 10)], 0) +
                coalesce(cc9.row_values[array_position(ct9.header_values, abs(v_delta_t0) - (abs(v_delta_t0) / 10) * 10)], 0))
            else coalesce(cc8.row_values[array_position(ct8.header_values, (v_delta_t0 / 10) * 10)], 0) +
                 coalesce(cc8.row_values[array_position(ct8.header_values, v_delta_t0 - (v_delta_t0 / 10) * 10)], 0)
            end as tt,
            case
                when p_equip_id = 2 then
                    case when v_spread < v_min_spread then v_wind_dir::integer
                    else v_wind_dir::integer + cc5.row_values[1] end
                else
                    case when v_wind_speed < v_min_wind_speed then v_wind_dir::integer
                    else v_wind_dir::integer + cc7.row_values[1] end
            end as hh,
            case when p_equip_id = 2 then
              (case when v_spread < v_min_spread then 0
               else cc4.row_values[array_position(ct4.header_values, round(v_spread / 10)::integer * 10)] end)
            else (case when v_wind_speed < v_min_wind_speed then 0
                 else cc6.row_values[array_position(ct6.header_values, round(v_wind_speed)::integer)] end)
            end as cc
        from calc_correction_heights h
        left join calc_correction cc9 on cc9.height_id = h.id and cc9.type_id = 9
        left join calc_correction_types ct9 on ct9.id = 9
        left join calc_correction cc8 on cc8.height_id = h.id and cc8.type_id = 8
        left join calc_correction_types ct8 on ct8.id = 8
        left join calc_correction cc4 on cc4.height_id = h.id and cc4.type_id = 4
        left join calc_correction_types ct4 on ct4.id = 4
        left join calc_correction cc5 on cc5.height_id = h.id and cc5.type_id = 5
        left join calc_correction cc6 on cc6.height_id = h.id and cc6.type_id = 6
        left join calc_correction_types ct6 on ct6.id = 6
        left join calc_correction cc7 on cc7.height_id = h.id and cc7.type_id = 7
        order by h.id;
    end;
    $body$;
    
    comment on procedure public.calculate_meteo_bulletin_proc(public.lst_parameter[], integer)
        is 'Расчёт метеобюллетеня: H, TT, HH, CC по всем высотам из таблицы';
end $$;