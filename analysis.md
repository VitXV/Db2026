# 1 Анализ закупки продукции

## таблица bm_StorageOperations

основные колонки с описанием и примерами

| column | описание | пример |
|---|---|---|
| ID |  id | 4780421 |
| DocumentID |  id документа  | 388235 |
| OperationID |  id операции  | 1 |
| BludoID |  id блюда  | 0 |
| ProductID |  id продукта  | 4368 |
| VendorID |  поставщик id | 200 |
| StorageID |  склад id | 41 |
| Price |  цена | 323.00 |
| PriceCost | Себестоимость | 0.00 |
| Count | Кол-во | 2.7640 |
| Amount | сумма | 892.77 |
| Period | Период | 202011 |
| DateAdd | дата добавления записи | 2020-11-15 14:15:30.183 |

### внешние ключи

`FK_bm_StorageOperations_bm_JournalBarnetDocs`

`FK_bm_StorageOperations_bm_StorageOperationsType`

`FK_bm_StorageOperations_product`

`FK_bm_StorageOperations_storages`

## таблица vendors - поставщики

| column | описание | пример |
|---|---|---|
| id | id поставщика | 90 |
| clientid | название | Габур |
| firstname | полное название |  ИП Габур |
| address | Адрес | Майск, ул.Димитрова, стр.17 |
| INN | ИНН | 380100067819 |
| IsUse | статус активности | 0 |

### внешний ключ

`FK_vendors_vendorgroup`

# 2 Анализ продажи товара. 

## таблица journal - продажи

| column | описание | пример |
|---|---|---|
| storeid | id магазина| 0 |
| receiptn | Номер чека | 14740696 |
| dater | Дата | 2020-11-10 09:49:09.000 |
| price | цена | 450.00 |
| amount | сумма | 450.00 |
| quantity | кол-во | 1.000 |
| description | описание | Пирог Камиль слоеный |
| discountamount | Сумма скидки | 40.00 |
| discount | Скидка % | 10.000 |
| customerid | id покупателя | 14740696 |
| transnumber | Номер транзакции | 1675584 |

внешний ключ `FK_journal_transtype_transtypeid` - id типа транзакции

## таблица bm_Journal_Details - детали чека, состав

| column | описание | пример |
|---|---|---|
| ID | id | 11530445 |
| SourceID | номер транзакции из journal.transnumber | 1675591 |
| ProductID | товар id | 4407 |
| BludoID | Блюдо id | 4451 |
| sBrutto | Масса брутто | 400.000 |
| Quantity | Кол-во | 1.0000 |
| DateAdd | дата добавления запсии | 2020-11-11 10:09:39.690 |

### внешние ключи

`FK_bm_Journal_Details_journal`

`FK_bm_Journal_Details_product`

`FK_bm_Journal_Details_product_BludoID`

`FK_bm_Journal_Details_size`

# 3  Анализ взаимоотношений с поставщиками. 

## таблица vendors - поставщики (см. выше)

таблица связана с vendorgroup, но там всего две группы: поставщики и без названия

## таблица bm_JournalBarnetDocs - документы поступления

| column | описание | пример |
|---|---|---|
| ID | id документа | 1216 |
| JournalID | Журнал id | 1 |
| DocumentNumber | Номер документа | 1 |
| Period | Дата | 2013-07-23 10:00:00.000 |
| DocumentTypeID | Тип документа | 1 |
| CompanyID | id компании | 6 |
| Amount | Сумма поступления | 0.00 |
| IsUse | статус активности | 1 |

### внешние ключи

`FK_bm_JournalBarnetDocs_bm_Companies`
`FK_bm_JournalBarnetDocs_bm_JournalBarnetInfo`
`FK_bm_JournalBarnetDocs_bm_JournalTypeDocuments`
`FK_bm_JournalBarnetDocs_bm_ShiftsOperations`

# 4 Анализ работы персонала. 

## таблица personnel - персонал

| column | описание | пример |
|---|---|---|
| personid | ID сотрудника | 897 |
| lastname | Фамилия | Безик |
| firstname | Имя | Татьяна |
| cityid | id города | 8 |
| securityaccess | Уровень доступа | 1 |
| usepassword | используется ли пароль | 1 |
| deleteflag | удален? | 1 |

внешних ключей нет

## таблица bm_JournalSessions - журнал действий сотрудников

| column | описание | пример |
|---|---|---|
| ID | id | 1 |
| Type | тип события, источник | Система |
| Message | сообщение | Произведена очистка журнала системных сообщений. |
| IsError | Ошибка? | 0 |
| DateAdd | Дата добавления | 2019-10-10 10:09:48 |
| PersonID | Сотрудник id | 897 |

внешних ключей нет

связан с personnel через PersonID

## bm_PersonnelSecurity - права сотрудников

| column | описание | пример |
|---|---|---|
| ID | id записи | 1397 |
| PersonID | Сотрудник id | 906 |
| ObjectID | Объект доступа, id | 36 |
| IsUse | Используется? | 1 |

внешний ключ FK_bm_PersonnelSecurity_bm_SecurityObjects

связан с personnel через PersonID

# 5 Остатки

## таблица bm_StorageOperations - движения товара по складам (см. выше)

## bm_StorageOperationsType - типы операций на складе

| column | описание | пример |
|---|---|---|
| ID | ID типа | `1` |
| Description | Название | `Поступление` |
| Factor | Знак движения | `1` |
| DateAdd | когда добавлена запись | 2013-01-15 15:19:12.517 |

# таблица bm_ReasonDebit - причины списания

| column | описание | пример |
|---|---|---|
| ID | ID причины | 1 |
| ParentID | родитель id | 0 |
| Description | Описание | Порча продукта |
| DateAdd | когда добавлена запись | 2015-07-14 10:29:13.340 |
| IsUse | Используется? | 1 |
