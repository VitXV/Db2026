--create database front;

do $$
begin

	begin
		-- storage operations types
		create sequence if not exists seq_storage_operations_types;
		
		create table if not exists storage_operations_types (
			id int primary key default nextval('seq_storage_operations_types'),
			external_id int,
			description text,
			factor int,
			date_add timestamp default now()
		);
		comment on table storage_operations_types is 'Тип операции';
		comment on column storage_operations_types.id is 'Идентификатор';
		comment on column storage_operations_types.external_id is 'Внешний id';
		comment on column storage_operations_types.factor is 'Фактор';
		comment on column storage_operations_types.date_add is 'Дата добавления';

		-- products
		create sequence if not exists seq_products;

		create table if not exists products(
			id int primary key default nextval('seq_products'),
			external_id int,
			product_id int,
			name text,
			vendor_id int,
			category_id int,
			size_id int,
			isused int,
			date_add timestamp default now()
		);
		comment on table products is 'Продукты';
		comment on column products.id is 'Идентификатор';
		comment on column products.external_id is 'Внешний id';
		comment on column products.product_id is 'id продукта';
		comment on column products.name is 'Название';
		comment on column products.vendor_id is 'id поставщика';
		comment on column products.category_id is 'id категории';
		comment on column products.size_id is 'id единицы измерения';
		comment on column products.isused is 'Используется ли продукт';
		comment on column products.date_add is 'Дата добавления';

		-- journal document types
		create sequence if not exists seq_journal_document_types;
		
		create table if not exists journal_document_types (
			id int primary key default nextval('seq_journal_document_types'),
			external_id int,
			description text,
			journal_id int,
			isparent int,
			date_add timestamp default now()
		);
		comment on table journal_document_types is 'Типы документов учетов';
		comment on column journal_document_types.id is 'Идентификатор';
		comment on column journal_document_types.external_id is 'Внешний id';
		comment on column journal_document_types.description is 'Название';
		comment on column journal_document_types.journal_id is 'id журнала';
		comment on column journal_document_types.isparent is 'Является ли главной таблицей';
		comment on column journal_document_types.date_add is 'Дата добавления';

		-- journal types
		create sequence if not exists seq_journal_types;

		create table if not exists journal_types (
			id int primary key default nextval('seq_journal_types'),
			external_id int,
			name text,
			date_add timestamp default now()
		);
		comment on table journal_types is 'Типы учетов';
		comment on column journal_types.id is 'Идентификатор';
		comment on column journal_types.external_id is 'Внешний id';
		comment on column journal_types.name is 'Название';
		comment on column journal_types.date_add is 'Дата добавления';

		-- vendors
		create sequence if not exists seq_vendors;

		create table if not exists vendors (
			id int primary key default nextval('seq_vendors'),
			external_id int,
			vendor_id text,
			vendor_group int,
			name text,
			isuse int,
			date_add timestamp default now()
		);
		comment on table vendors is 'Поставщики';
		comment on column vendors.id is 'Идентификатор';
		comment on column vendors.external_id is 'Внешний id';
		comment on column vendors.vendor_id is 'id поставщика';
		comment on column vendors.vendor_group is 'Группа поставщика';
		comment on column vendors.name is 'Наименование';
		comment on column vendors.isuse is 'Есть ли договор';
		comment on column vendors.date_add is 'Дата добавления';

		-- storages
		create sequence if not exists seq_storages;

		create table storages (
			id int primary key default nextval('seq_storages'),
			external_id int,
			name text,
			date_add timestamp default now()
		);
		comment on table storages is 'Склады';
		comment on column storages.id is 'Идентификатор';
		comment on column storages.external_id is 'Внешний idddd';
		comment on column storages.name is 'Название';
		comment on column storages.date_add is 'Дата добавления';

		-- employees
		create sequence if not exists seq_employees;

		create table employees (
			id int primary key default nextval('seq_employees'),
			external_id int,
			firstname text,
			lastname text,
			middlename text,
			security_access int,
			date_add timestamp default now()
		);
		comment on table employees is 'Сотрудники';
		comment on column employees.id is 'Идентификатор';
		comment on column employees.external_id is 'Внешний id';
		comment on column employees.firstname is 'Имя';
		comment on column employees.lastname is 'Фамилия';
		comment on column employees.middlename is 'Отчество';
		comment on column employees.security_access is 'id доступа';
		comment on column employees.date_add is 'Дата добавления';

		-- size
		create sequence if not exists seq_size;

		create table size(
			id int primary key default nextval('seq_size'),
			external_id int,
			name text,
			factor float,
			date_add timestamp default now()
		);
		comment on table size is 'Единицы измерения';
		comment on column size.id is 'Идентификатор';
		comment on column size.external_id is 'Внешний id';
		comment on column size.name is 'Название единицы измерения';
		comment on column size.factor is 'Количество в порции';
		comment on column size.date_add is 'Дата добавления';
		
		-- trans types
		create sequence if not exists seq_trans_types;

		create table if not exists trans_types(
			id int primary key default nextval('seq_trans_types'),
			external_id int,
			group_id int,
			preview_group_type text,
			description text,
			date_add timestamp default now()
		);
		comment on table trans_types is 'Строки чеков';
		comment on column trans_types.id is 'Идентификатор';
		comment on column trans_types.external_id is 'Внешний id';
		comment on column trans_types.group_id is 'id группы';
		comment on column trans_types.preview_group_type is 'Тип группы';
		comment on column trans_types.description is 'Описание';
		comment on column trans_types.date_add is 'Дата добавления';

		-- vendors groups
		create sequence if not exists seq_vendors_groups;

		create table if not exists vendors_groups(
			id int primary key default nextval('seq_vendors_groups'),
			external_id int,
			description text,
			date_add timestamp default now()
		);
		comment on table vendors_groups is 'Группы поставщиков';
		comment on column vendors_groups.id is 'Идентификатор';
		comment on column vendors_groups.description is 'Название';
		comment on column vendors_groups.date_add is 'Дата добавления';

		-- debit reason
		create sequence if not exists seq_debit_reason;

		create table if not exists debit_reason(
			id int primary key default nextval('seq_debit_reason'),
			external_id int,
			parent_id int,
			description text,
			isuse int,
			date_add timestamp default now()
		);
		comment on table debit_reason is 'Причины списания';
		comment on column debit_reason.id is 'Идентификатор';
		comment on column debit_reason.external_id is 'Внешний id';
		comment on column debit_reason.parent_id is 'id основной таблицы';
		comment on column debit_reason.description is 'Описание';
		comment on column debit_reason.isuse is 'Используется ли';
		comment on column debit_reason.date_add is 'Дата добавления';
	end;
	
commit;
end $$;