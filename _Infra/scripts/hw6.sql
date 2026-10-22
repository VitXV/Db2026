do $$
	begin;
	    -- Преобразование таблицы temperature
	    alter table temperature drop column if exists name;
	    alter table temperature drop column if exists coof;
	    alter table temperature drop column if exists corr;
	    
	    alter table temperature add column if not exists t0_range text;
	    alter table temperature add column if not exists correction_value numeric(3,1);
	    alter table temperature add column if not exists t0_val numeric;
	
	    truncate table temperature;
	
	    -- ПРАВИЛЬНЫЕ ДАННЫЕ СОГЛАСНО ТАБЛИЦЕ 1 ИЗ ТЗ
	    insert into temperature (id, t0_range, correction_value, t0_val) values
	        (1, 'Ниже 0', 0, 0), 
	        (2, '0-5', 0.5, 5), 
	        (3, '10-15', 1, 15), 
	        (4, '20', 1.5, 20),
	        (5, '25', 2, 25), 
	        (6, '30', 3.5, 30),
	        (7, '40', 4.5, 40);
	
	    drop type if exists interpolation_points cascade;
	
	    create type interpolation_points as (
	        x0 numeric,
	        y0 numeric,
	        x1 numeric,
	        y1 numeric
	    );
	
	    create or replace function get_interpolation_points(t numeric)
	    returns interpolation_points
	    language plpgsql
	    as $func$
	    declare
	        result interpolation_points;
	    begin
	        select x0, y0, x1, y1 into result
	        from (
	            select
	                lag(t0_val) over (order by t0_val) as x0,
	                lag(correction_value) over (order by t0_val) as y0,
	                t0_val as x1,
	                correction_value as y1
	            from temperature
	            where t0_val is not null
	            order by t0_val
	        ) as pairs
	        where t >= x0 and t < x1
	        limit 1;
	
	        if result.x0 is null then
	            if t < 0 then
	                result := (0::numeric, 0::numeric, 0::numeric, 0::numeric);
	            else
	                select t0_val, correction_value, t0_val, correction_value
	                into result.x0, result.y0, result.x1, result.y1
	                from temperature
	                where t0_val is not null
	                order by t0_val desc
	                limit 1;
	            end if;
	        end if;
	
	        return result;
	    end;
	    $func$;
	
	    create or replace function interpolate(x numeric, points interpolation_points)
	    returns numeric
	    language plpgsql
	    as $func$
	    begin
	        if points.x0 = points.x1 then
	            return points.y0;
	        elsif x <= points.x0 then
	            return points.y0;
	        elsif x >= points.x1 then
	            return points.y1;
	        else
	            return points.y0 + (points.y1 - points.y0) * (x - points.x0) / (points.x1 - points.x0);
	        end if;
	    end;
	    $func$;
	commit;
end $$;