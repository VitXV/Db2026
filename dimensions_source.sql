-- Единицы изм
select id, sizeid as name, 
portionrate as factor from [size] 

select 'insert into dim_ranges(external_id, name, factor ) values ('
    + cast(id as varchar(max)) + ','''   
    + [sizeid] + ''','  
    + caST(portionrate as varchar(max))   + ');' 
    as [sql]
 from [size] 



-- категории
select * FROM
(
select id,  description as name,
   case when coalesce( ParentID,0) = 0 
        then null else parentId end as parent_id
          from category
) as t1
order  by parent_id, name

-- Поставщики
select * FROM
(
    select id,  clientid as name, clientgroup as parent_id,
    t2.[description] as parent_name
    from vendors t1
    inner join vendorgroup t2 on t1.clientgroup = t2.vendorgroupid
) as t1 order by parent_id