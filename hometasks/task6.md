

# Домашнее задание 6
## Условие задания

### Задача 1
Возьмите реляционную схему для библиотеки сделаную в задании 3.1:  
  
* Reader( <ins>number</ins>, LastName, FirstName, Address, BirthDate) <br>  
* Book ( <ins>isbn</ins>, Title, Author, PagesNum, PubYear, PubName) <br>  
* Publisher ( <ins>PubName</ins>, PubAdress) <br>  
* Category ( <ins>CategoryName</ins>, ParentCat) <br>  
* Copy ( <ins>ISBN, CopyNumber</ins>,, ShelfPosition) <br>  
* Borrowing ( <ins>ReaderNr, ISBN, CopyNumber</ins>, ReturnDate) <br>  
* BookCat ( <ins>ISBN, CategoryName</ins> )  
  
Напишите SQL-запросы:  
  
* Показать все названия книг вместе с именами издателей.  
* В какой книге наибольшее количество страниц?  
* Какие авторы написали более 5 книг?  
* В каких книгах более чем в два раза больше страниц, чем среднее 
количество страниц для всех книг?  
* Какие категории содержат подкатегории?  
* У какого автора (предположим, что имена авторов уникальны) написано 
максимальное количество книг?  
* Какие читатели забронировали все книги (не копии), написанные "Марком 
Твеном"?  
* Какие книги имеют более одной копии?  
* ТОП 10 самых старых книг  
* Перечислите все категории в категории “Спорт” (с любым уровнем 
вложености).
### Задача 2 
Напишите SQL-запросы для следующих действий:  
* Добавьте запись о бронировании читателем ‘Василеем Петровым’ книги с 
ISBN 123456 и номером копии 4.  
* Удалить все книги, год публикации которых превышает 2000 год.  
* Измените дату возврата для всех книг категории "Базы данных", начиная с 
01.01.2016, чтобы они были в заимствовании на 30 дней дольше (предположим, 
что в SQL можно добавлять числа к датам). 
### Задача 3  
Рассмотрим следующую реляционную схему:  
  
* Student( MatrNr, Name, Semester )  
* Check( MatrNr, LectNr, ProfNr, Note )  
* Lecture( LectNr, Title, Credit, ProfNr )  
* Professor( ProfNr, Name, Room )  
  
Опишите на русском языке результаты следующих запросов:  
 
```sql  
SELECT s.Name, s.MatrNr FROM Student s  
WHERE NOT EXISTS (  
SELECT * FROM Check c WHERE c.MatrNr = s.MatrNr AND c.Note >= 4.0 ) ;  
```  
  
```sql  
( SELECT p.ProfNr, p.Name, sum(lec.Credit)  
FROM Professor p, Lecture lec  
WHERE p.ProfNr = lec.ProfNr  
GROUP BY p.ProfNr, p.Name)  
UNION  
( SELECT p.ProfNr, p.Name, 0  
FROM Professor p  
WHERE NOT EXISTS (  
SELECT * FROM Lecture lec WHERE lec.ProfNr = p.ProfNr ));  
```  
  
```sql  
SELECT s.Name, p.Note  
FROM Student s, Lecture lec, Check c  
WHERE s.MatrNr = c.MatrNr AND lec.LectNr = c.LectNr AND c.Note >= 4  
AND c.Note >= ALL (  
SELECT c1.Note FROM Check c1 WHERE c1.MatrNr = c.MatrNr )
```

## Решение
### Задача 1
* Показать все названия книг вместе с именами издателей.  
```
SELECT Book.Title, Book.PubName
FROM Book;
```
* В какой книге наибольшее количество страниц?  
```
SELECT TOP 1 Title FROM Book ORDER  BY PagesNum DESC;
```
* Какие авторы написали более 5 книг?  
```
SELECT Author, COUNT(*) as BookCount
FROM Book
GROUP BY Author
HAVING COUNT(*) > 5;
```
* В каких книгах более чем в два раза больше страниц, чем среднее 
количество страниц для всех книг?  
```
SELECT Title
FROM Book
WHERE PagesNum > 2 * (SELECT AVG(PagesNum) FROM Book);
```
* Какие категории содержат подкатегории? 
```
SELECT DISTINCT C1.CategoryName
FROM Category C1
JOIN Category C2 ON C1.CategoryName = C2.ParentCat;
``` 
* У какого автора (предположим, что имена авторов уникальны) написано 
максимальное количество книг?  
```
SELECT TOP 1 Author, COUNT(*) as BookCount
FROM Book
GROUP BY Author
ORDER BY BookCount DESC;
```
* Какие читатели забронировали все книги (не копии), написанные "Марком 
Твеном"?  
```
SELECT B.ReaderNr
FROM Borrowing B
JOIN Book Bk ON B.ISBN = Bk.ISBN
WHERE Bk.Author = 'Марк Твен'
GROUP BY B.ReaderNr
HAVING COUNT(DISTINCT B.ISBN) = (SELECT COUNT(*) FROM Book WHERE Author = 
'Марк Твен');
```
* Какие книги имеют более одной копии?  
```
SELECT Title
FROM Copy
JOIN Book ON Copy.ISBN = Book.ISBN
GROUP BY Title
HAVING COUNT(*) > 1;
```
* ТОП 10 самых старых книг  
```
SELECT TOP 10 Title, PubYear
FROM Book
ORDER BY PubYear;
```
* Перечислите все категории в категории “Спорт” (с любым уровнем 
вложености)
```
WITH RecursiveCategory AS (
  SELECT CategoryName, ParentCat
  FROM Category
  WHERE ParentCat = 'Спорт'
  UNION ALL
  SELECT C.CategoryName, C.ParentCat
  FROM Category C
  JOIN RecursiveCategory RC ON C.ParentCat = RC.CategoryName
)
SELECT DISTINCT CategoryName
FROM RecursiveCategory;
```

### Задача 2
Напишите SQL-запросы для следующих действий:  
  
* Добавьте запись о бронировании читателем ‘Василеем Петровым’ книги с 
ISBN 123456 и номером копии 4.  
```
INSERT INTO Borrowing (ReaderNr, ISBN, CopyNumber, ReturnDate)
VALUES (
    (SELECT number FROM Reader WHERE LastName = 'Петров' AND FirstName = 
'Василий'),
    '123456',
    4,
    NULL
);

```
* Удалить все книги, год публикации которых превышает 2000 год.
```
DELETE FROM Book
WHERE PubYear > 2000;
```  
* Измените дату возврата для всех книг категории "Базы данных", начиная с 
01.01.2016, чтобы они были в заимствовании на 30 дней дольше (предположим, 
что в SQL можно добавлять числа к датам). 
```
UPDATE Borrowing
SET ReturnDate = DATEADD(day, 30, ReturnDate)
WHERE ISBN IN (SELECT ISBN FROM BookCat WHERE CategoryName = 'Базы 
данных')
  AND ReturnDate >= '2016-01-01';
```
### Задача 3
Рассмотрим следующую реляционную схему:  
  
* Student( MatrNr, Name, Semester )  
* Check( MatrNr, LectNr, ProfNr, Note )  
* Lecture( LectNr, Title, Credit, ProfNr )  
* Professor( ProfNr, Name, Room )  
  
Опишите на русском языке результаты следующих запросов:  

   **Выбрать имена и номера студентов, у которых нет оценок 4.0 и выше.**
```sql  
SELECT s.Name, s.MatrNr FROM Student s  
WHERE NOT EXISTS (  
SELECT * FROM Check c WHERE c.MatrNr = s.MatrNr AND c.Note >= 4.0 ) ;  
```  
---
**Список профессоров с суммарным кредитом лекций, которые они ведут, и 
профессоров, которые не ведут лекций**
```sql  
( SELECT p.ProfNr, p.Name, sum(lec.Credit)  
FROM Professor p, Lecture lec  
WHERE p.ProfNr = lec.ProfNr  
GROUP BY p.ProfNr, p.Name)  
UNION  
( SELECT p.ProfNr, p.Name, 0  
FROM Professor p  
WHERE NOT EXISTS (  
SELECT * FROM Lecture lec WHERE lec.ProfNr = p.ProfNr ));  
```  
  ---
  **Выбрать имена студентов и оценки, которые выше или равны 4.0 и 
превосходят все другие оценки этого студента**
```sql  
SELECT s.Name, p.Note  
FROM Student s, Lecture lec, Check c  
WHERE s.MatrNr = c.MatrNr AND lec.LectNr = c.LectNr AND c.Note >= 4  
AND c.Note >= ALL (  
SELECT c1.Note FROM Check c1 WHERE c1.MatrNr = c.MatrNr )
```



