-- storage_operations_types
select 'insert into storage_operations_types(external_id, description, factor) values ('
    + cast(front.dbo.bm_storageoperationstype.id as varchar(max)) + ','''
    + front.dbo.bm_storageoperationstype.[description] + ''','
    + cast(front.dbo.bm_storageoperationstype.factor as varchar(max)) + ');'
    as sql
from front.dbo.bm_storageoperationstype;

-- products
select 'insert into products(external_id, name, vendor_id, category_id, size_id, is_used) values('
    + cast(front.dbo.product.id as varchar(max)) + ','''
    + front.dbo.product.[description] + ''','
    + cast(front.dbo.product.vendorid as varchar(max)) + ','
    + cast(front.dbo.product.categoryid as varchar(max)) + ','
    + cast(front.dbo.product.sizeid as varchar(max)) + ','
    + cast(front.dbo.product.isuse as varchar(max)) + ');'
as sql
from front.dbo.product;

-- journal_types
select 'insert into journal_types(external_id, name) values('
    + cast(front.dbo.bm_journaltype.id as varchar(max)) + ','''
    + front.dbo.bm_journaltype.journalname + ''');'
as sql
from front.dbo.bm_journaltype;

-- vendors
select 'insert into vendors(external_id, vendor_group, name, is_used) values ('
    + cast(front.dbo.vendors.id as varchar(max)) + ','
    + cast(front.dbo.vendors.clientgroup as varchar(max)) + ','''
    + front.dbo.vendors.firstname + ''','
    + cast(front.dbo.vendors.isuse as varchar(max)) + ');'
as sql
from front.dbo.vendors;

-- personnel
select 'insert into employees(external_id, firstname, lastname, middlename, security_access) values ('
    + cast(front.dbo.personnel.personid as varchar(max)) + ','''
    + front.dbo.personnel.firstname + ''','''
    + front.dbo.personnel.lastname + ''','''
    + front.dbo.personnel.middlename + ''','
    + cast(front.dbo.personnel.securityaccess as varchar(max)) + ');'
as sql
from front.dbo.personnel;

-- size
select 'insert into size(external_id, name, factor) values ('
    + cast(front.dbo.size.id as varchar(max)) + ','''   
    + front.dbo.size.sizeid + ''','  
    + cast(front.dbo.size.portionrate as varchar(max))   + ');' 
    as sql
from front.dbo.size;

-- trans_types
select 'insert into trans_types(external_id, group_id, preview_group_type, description) values ('
    + cast(front.dbo.transtype.transtypeid as varchar(max)) + ','
    + cast(front.dbo.transtype.transgroupid as varchar(max)) + ','''
    + front.dbo.transtype.previewgrouptype + ''','''
    + front.dbo.transtype.[description] + ''');'
as sql
from front.dbo.transtype;