-- 1 ДМК t=25 6 м/с
do $$
begin
    call public.calculate_meteo_bulletin_proc(
        array[(1, 2, 25.0)::lst_parameter, (1, 3, 765.0)::lst_parameter, (1, 4, 15.0)::lst_parameter, (1, 5, 6.0)::lst_parameter, (1, 6, 0.0)::lst_parameter],
        1
    );
end $$;
select * from tmp_bulletin order by h;

-- 2 ВР t=25 снос 50м
do $$
begin
    call public.calculate_meteo_bulletin_proc(
        array[(1, 2, 25.0)::lst_parameter, (1, 3, 765.0)::lst_parameter, (1, 4, 15.0)::lst_parameter, (1, 5, 0.0)::lst_parameter, (1, 6, 50.0)::lst_parameter],
        2
    );
end $$;
select * from tmp_bulletin order by h;