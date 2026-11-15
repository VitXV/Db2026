-- 1 Закупки продукции

-- bm_StorageOperations и vendors - VendorID
SELECT COUNT(*) AS Всего,
       COUNT(v.id) AS Нашлось
FROM dbo.bm_StorageOperations s
LEFT JOIN dbo.vendors v ON v.id = s.VendorID
WHERE s.VendorID <> 0;

-- bm_StorageOperations и product - BludoID
SELECT COUNT(*) AS Всего,
       COUNT(p.id) AS Нашлось
FROM dbo.bm_StorageOperations s
LEFT JOIN dbo.product p ON p.id = s.BludoID
WHERE s.BludoID <> 0;

-- 2 Продажи товара

-- bm_StorageOperations_Table и journal через SourceID
SELECT COUNT(*) AS Всего, COUNT(j.transnumber) AS Нашлось
FROM dbo.bm_StorageOperations_Table t
LEFT JOIN dbo.journal j ON j.transnumber = t.SourceID;

-- 3 Взаимоотношения с поставщиками

-- bm_JournalBarnetDocs и journal через TicketNumber
SELECT COUNT(*) AS Всего, COUNT(j.receiptn) AS Нашлось
FROM dbo.bm_JournalBarnetDocs b
LEFT JOIN dbo.journal j ON j.receiptn = b.TicketNumber;

-- 4 Работа персонала

-- personnel и journal через loginid
SELECT COUNT(*) AS Всего, COUNT(p.personid) AS Нашлось
FROM dbo.journal j
LEFT JOIN dbo.personnel p ON p.personid = j.loginid;

-- personnel и bm_JournalBarnetDocs через PersonID
SELECT COUNT(*) AS Всего, COUNT(p.personid) AS Нашлось
FROM dbo.bm_JournalBarnetDocs b
LEFT JOIN dbo.personnel p ON p.personid = b.PersonID;

-- personnel и bm_JournalSessions через PersonID
SELECT COUNT(*) AS Всего, COUNT(p.personid) AS Нашлось
FROM dbo.bm_JournalSessions s
LEFT JOIN dbo.personnel p ON p.personid = s.PersonID;

-- personnel и bm_PersonnelSecurity через PersonID
SELECT COUNT(*) AS Всего, COUNT(p.personid) AS Нашлось
FROM dbo.bm_PersonnelSecurity x
LEFT JOIN dbo.personnel p ON p.personid = x.PersonID;

-- 5 Остатки

-- bm_StorageOperations и bm_ReasonDebit через ReasonID
SELECT COUNT(*) AS Всего, COUNT(r.ID) AS Нашлось
FROM dbo.bm_StorageOperations s
LEFT JOIN dbo.bm_ReasonDebit r ON r.ID = s.ReasonID
WHERE s.ReasonID <> 0;

-- bm_ReasonDebit сам с собой через ParentID
SELECT COUNT(*) AS Всего, COUNT(par.ID) AS Нашлось
FROM dbo.bm_ReasonDebit r
LEFT JOIN dbo.bm_ReasonDebit par ON par.ID = r.ParentID
WHERE r.ParentID <> 0;