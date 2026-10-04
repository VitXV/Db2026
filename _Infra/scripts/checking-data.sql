-- 1

select u.user_id, u.firstname, u.lastname, count(l.log_id) 
from users u
left join logs l on u.user_id = l.user_id
group by u.user_id, u.firstname, u.lastname
order by u.user_id;

-- 2

select l.log_id, l.user_id
from logs l
left join parameters p on l.log_id = p.log_id
where p.log_id is null;

-- 3
-- В моём случае 6 измерений, есть ещё дальность сноса пуль

select l.log_id
from logs l 
where (
    select count(*)
    from parameters p
    where p.log_id = l.log_id
) != 6;

-- проверка
select log_id, count(*) from parameters
where log_id in (1,2,3)
group by log_id;

-- 4

SELECT 
    p.log_id,
    tp.type_name,
    p.val,
    CASE 
        WHEN p.type_id = 2 AND (p.val < -58 OR p.val > 58) THEN 'Температура вне диапазона [-58, 58] °C'
        WHEN p.type_id = 3 AND (p.val < 500 OR p.val > 900) THEN 'Давление вне диапазона [500, 900] мм рт. ст.'
        WHEN p.type_id = 4 AND (p.val < 0 OR p.val > 59) THEN 'Направление ветра вне диапазона [0, 59] б.д.у.'
        WHEN p.type_id = 5 AND (p.val < 0 OR p.val > 15) THEN 'Скорость ветра вне диапазона [0, 15] м/с'
        WHEN p.type_id = 6 AND (p.val < 0 OR p.val > 150) THEN 'Дальность сноса вне диапазона [0, 150] м'
    END AS error_description
FROM parameters p
JOIN types_of_parameters tp ON p.type_id = tp.type_id
WHERE 
    (p.type_id = 2 AND (p.val < -58 OR p.val > 58)) OR
    (p.type_id = 3 AND (p.val < 500 OR p.val > 900)) OR
    (p.type_id = 4 AND (p.val < 0 OR p.val > 59)) OR
    (p.type_id = 5 AND (p.val < 0 OR p.val > 15)) OR
    (p.type_id = 6 AND (p.val < 0 OR p.val > 150));

-- доп. проверка на единицы измерения
select * from parameters p where
p.type_id = 2 and p.unit_id != 6 or
p.type_id = 3 and p.unit_id != 9 or
p.type_id = 4 and p.unit_id != 13 or
p.type_id = 5 and p.unit_id != 15 or
p.type_id = 6 and p.unit_id != 1;
-- других единиц кроме стандарных нет

-- 5

select * from parameters
where 
type_id = 1 and unit_id not in (1,2,3,4,5) or
type_id = 2 and unit_id not in (6,7,8) or
type_id = 3 and unit_id not in (9,10,11,12) or
type_id = 4 and unit_id not in (13,14) or
type_id = 5 and unit_id not in (15,16,17,18) or
type_id = 6 and unit_id not in (1,2,3,4,5);