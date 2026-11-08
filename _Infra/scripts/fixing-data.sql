-- Учебный скрипт даже не запускается, просто ужас. Я хотел поменять его, но потом увидел, что за это баллы снимаются...

do $$
begin

	begin
		-- таблица 2, корректный заголовок
		update calc_correction_types
		set header_values = array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50]
		where id in (1, 8, 9);

		-- исправления type_id и температуры
		update calc_correction
		set type_id = 8
		where type_id = 7 and array_length(row_values, 1) = 12;

		update calc_correction
		set type_id = 9
		where type_id = 8 and row_values[1] < 0;

		-- отрицательные температуры для всех высот
		update calc_correction set row_values = array[-1, -2, -3, -4, -5, -6, -7, -8, -8, -9, -20, -29, -39, -49] where height_id = 1 and type_id = 9;
		update calc_correction set row_values = array[-1, -2, -3, -4, -5, -6, -6, -7, -8, -9, -19, -29, -38, -48] where height_id = 2 and type_id = 9;
		update calc_correction set row_values = array[-1, -2, -3, -4, -5, -6, -6, -7, -7, -8, -18, -28, -37, -46] where height_id = 3 and type_id = 9;
		update calc_correction set row_values = array[-1, -2, -3, -4, -4, -5, -5, -6, -7, -8, -17, -26, -35, -44] where height_id = 4 and type_id = 9;

		-- положительные температуры
		update calc_correction
		set row_values = array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]
		where type_id = 8;
	end;

	-- добавление данных
	begin
		-- таблица 2 отрицательные температуры
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 9, array[-1, -2, -3, -3, -4, -4, -5, -6, -7, -7, -17, -25, -34, -42]),
		(6, 9, array[-1, -2, -3, -3, -4, -4, -5, -6, -6, -7, -16, -24, -32, -40]),
		(7, 9, array[-1, -2, -2, -3, -4, -4, -5, -5, -6, -7, -15, -23, -31, -38]),
		(8, 9, array[-1, -2, -2, -3, -4, -4, -4, -5, -5, -6, -15, -22, -30, -37]),
		(9, 9, array[-1, -2, -2, -3, -4, -4, -4, -4, -5, -6, -14, -20, -27, -34]);

		-- таблица 2 положительные температуры 
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]),
		(6, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]),
		(7, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]),
		(8, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]),
		(9, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, NULL, NULL]);

		-- таблица 3, ВР, скорость среднего ветра 
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17, 17]),
		(6, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18]),
		(7, 4, array[4, 6, 8, 9, 9, 10, 12, 14, 15, 16, 18, 19]),
		(8, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 15, 17, 18, 19]),
		(9, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18, 19, 20]);

		-- таблица 3, ВР, направление среднего ветра
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 5, array[3]),
		(6, 5, array[3]),
		(7, 5, array[3]),
		(8, 5, array[4]),
		(9, 5, array[4]);

		-- таблица 3, ДМК, скорость среднего ветра
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 6, array[6, 8, 11, 13, 14, 17, 20, 21, 23, 25, 27, 29, 32]),
		(6, 6, array[6, 9, 11, 13, 14, 17, 20, 21, 24, 26, 28, 30, 32]),
		(7, 6, array[6, 9, 12, 14, 15, 18, 21, 22, 25, 27, 29, 32, 34]),
		(8, 6, array[6, 9, 12, 14, 15, 18, 21, 23, 25, 28, 30, 32, 36]),
		(9, 6, array[6, 10, 12, 14, 16, 19, 22, 24, 26, 29, 32, 34, 36]);

		-- таблица 3, ДМК, направление среднего ветра 
		insert into calc_correction (height_id, type_id, row_values) values
		(5, 7, array[4]),
		(6, 7, array[4]),
		(7, 7, array[4]),
		(8, 7, array[5]),
		(9, 7, array[5]);
	end;

	begin
		alter table calc_correction_types drop constraint if exists fk_calc_correction_types_header;

		if exists (
			select 1 from information_schema.columns
			where table_name = 'calc_correction_types'
			and column_name = 'header_id'
		) then
			alter table calc_correction_types drop column header_id;
		end if;

		drop table if exists headers;
		create table headers (
			id int primary key,
			val int[]
		);

		insert into headers (id, val)
		select
			row_number() over (),
			header_values
		from calc_correction_types
		where header_values is not null
		group by header_values;

		alter table calc_correction_types add column header_id int;

		update calc_correction_types t
		set header_id = h.id
		from headers h
		where t.header_values = h.val;

		alter table calc_correction_types
		add constraint fk_calc_correction_types_header
		foreign key (header_id) references headers(id);
	end;

end $$;

select t.id, t.description, t.header_id, h.val
from calc_correction_types t
left join headers h on h.id = t.header_id 
order by t.id;