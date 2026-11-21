-- bm_StorageOperationsType
select 'insert into storage_operations_types(external_id, description, factor) values ('
    + cast(front.dbo.bm_StorageOperationsType.ID as varchar(max)) + ','''
    + front.dbo.bm_StorageOperationsType.[description] + ''','
    + cast(front.dbo.bm_StorageOperationsType.Factor as varchar(max)) + ');'
    as sql
from front.dbo.bm_StorageOperationsType;

-- product
select 'insert into products(external_id, product_id, name, vendor_id, category_id, size_id, isused) values('
+ cast(front.dbo.product.ID as varchar(max)) + ','
+ cast(front.dbo.product.productid as varchar(max)) + ','''
+ front.dbo.product.[description] + ''','
+ cast(front.dbo.product.vendorid as varchar(max)) + ','
+ cast(front.dbo.product.CategoryID as varchar(max)) + ','
+ cast(front.dbo.product.SizeID as varchar(max)) + ','
+ cast(front.dbo.product.IsUse as varchar(max)) + ');'
as sql
from front.dbo.product;

-- bm_JournalTypeDocuments
select 'insert into journal_document_types(external_id, description, journal_id, isparent) values ('
    + cast(front.dbo.bm_JournalTypeDocuments.ID as varchar(max)) + ','''
    + front.dbo.bm_JournalTypeDocuments.[description] + ''','
    + cast(front.dbo.bm_JournalTypeDocuments.JournalID as varchar(max)) + ','
    + cast(front.dbo.bm_JournalTypeDocuments.isParent as varchar(max))  + ');'
    as sql
from front.dbo.bm_JournalTypeDocuments;

-- bm_JournalType
select 'insert into journal_types(external_id, name) values('
+ cast(front.dbo.bm_JournalType.ID as varchar(max)) + ','''
+ front.dbo.bm_JournalType.JournalName + ''');'
as sql
from front.dbo.bm_JournalType;

-- vendors
select 'insert into vendors(external_id, vendor_id, vendor_group, name, isuse) values ('
+ cast(front.dbo.vendors.id as varchar(max)) + ','''
+ front.dbo.vendors.clientid + ''','
+ cast(front.dbo.vendors.clientgroup as varchar(max)) + ','''
+ front.dbo.vendors.firstname + ''','
+ cast(front.dbo.vendors.IsUse as varchar(max)) + ');'
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
select 'insert into size(external_id, name, factor ) values ('
    + cast(front.dbo.size.id as varchar(max)) + ','''   
    + front.dbo.size.sizeid + ''','  
    + caST(front.dbo.size.portionrate as varchar(max))   + ');' 
    as sql
 from front.dbo.size

 -- transtype 
 select 'insert into trans_types(external_id, group_id, preview_group_type, description) values ('
 + cast(front.dbo.transtype.transtypeid as varchar(max)) + ','
 + cast(front.dbo.transtype.transgroupid as varchar(max)) + ','''
 + front.dbo.transtype.PreviewGroupType + ''','''
 + front.dbo.transtype.[description] + ''');'
 as sql
 from front.dbo.transtype;