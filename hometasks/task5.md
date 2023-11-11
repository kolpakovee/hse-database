
# Домашнее задание 5
## Условие задания

### Задача 1
Возьмите библиотечную систему, схему которой сделали на предыдущем задании  
  
Reader( ID, LastName, FirstName, Address, BirthDate) 
Book ( ISBN, Title, Author, PagesNum, PubYear, PubName) 
Publisher ( PubName, PubAdress) 
Category ( CategoryName, ParentCat) 
Copy ( ISBN, CopyNumber, ShelfPosition) 
Borrowing ( ReaderNr, ISBN, CopyNumber, ReturnDate)
BookCat ( ISBN, CategoryName )  
  
Напишите SQL-запросы для следующих вопросов:  
  
- Какие фамилии читателей в Москве?
- Какие книги (author, title) брал Иван Иванов? 
- Какие книги (ISBN) из категории "Горы" не относятся к категории 
"Путешествия"? Подкатегории не обязательно принимать во внимание!  
- Какие читатели (LastName, FirstName) вернули копию книги?
- Какие читатели (LastName, FirstName) брали хотя бы одну книгу (не 
копию), которую брал также Иван Иванов (не включайте Ивана Иванова в 
результат)?
  
### Задача 2  
  
Возьмите схему для Поездов, которую выполняли в предыдущем задании.  
 
City ( Name, Region )
Station ( Name, #Tracks, CityName, Region )
Train ( TrainNr, Length, StartStationName, EndStationName ) 
Connection ( FromStation, ToStation, TrainNr, Departure, Arrival) 
  
Предположим, что отношение "Connection" уже содержит транзитивное 
замыкание. Когда поезд 101 отправляется из Москвы в Санкт-Петербург через 
Тверь, содержит кортежи для связи Москва->Тверь, Тверь-Санкт-Петербург и 
Москва->Санкт-Петербург. Сформулируйте следующие запросы:  
  
- Найдите все прямые рейсы из Москвы в Тверь. 
- Найдите все многосегментные маршруты, имеющие точно однодневный трансфер 
из Москвы в Санкт-Петербург (первое отправление и прибытие в конечную 
точку должны быть в одну и ту же дату). Вы можете применить функцию DAY () 
к атрибутам Departure и Arrival, чтобы определить дату. 

## Решение
### Задача 1
Какие фамилии читателей в Москве?
```
SELECT LastName 
FROM Reader 
WHERE Address = 'Moscow';                                                                                                                                                                                                                                                                                                                      
```
![1](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_1_a.png)
Какие книги (author, title) брал Иван Иванов? 
```
SELECT DISTINCT b.Author, b.Title 
FROM Borrowing bor 
JOIN Reader r ON bor.ReaderNr = r.ID
JOIN Book b ON bor.ISBN = b.ISBN
WHERE r.LastName = 'Doe' AND r.FirstName = 'John';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
```
![2](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_1_b.png)
Какие книги (ISBN) из категории "Горы" не относятся к категории 
"Путешествия"? Подкатегории не обязательно принимать во внимание!  
```
SELECT isbn                                                                                                                                                       
FROM bookcat                                                                                                                                                                     
WHERE categoryname = 'Горы'                                                                                                                                                      
AND isbn NOT IN (SELECT isbn FROM bookcat WHERE categoryname = 
'Путешествия');
```
![3](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_1_c.png)
Какие читатели (LastName, FirstName) вернули копию книги?
```
SELECT  DISTINCT r.LastName, r.FirstName 
FROM Borrowing bor 
JOIN Reader r ON bor.ReaderNr = r.ID 
WHERE bor.ReturnDate IS  NOT  NULL;
```
![4](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_1_d.png)
Какие читатели (LastName, FirstName) брали хотя бы одну книгу (не копию), 
которую брал также Иван Иванов (не включайте Ивана Иванова в результат)?
```
SELECT  DISTINCT r.LastName, r.FirstName 
FROM Borrowing b1 
JOIN Reader r ON b1.ReaderNr = r.ID 
WHERE b1.ISBN IN 

( SELECT  DISTINCT b2.ISBN 
FROM Borrowing b2 
JOIN Reader r2 ON b2.ReaderNr = r2.ID 
WHERE r2.LastName =  'Ivanov'  AND r2.FirstName =  'Ivan' ) 

AND r.LastName !=  'Ivanov'  AND r.FirstName !=  'Ivan';
```
![5](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_1_e.png)

## Задача 2
Найдите все прямые рейсы из Москвы в Тверь.
```
SELECT  DISTINCT C1.TrainNr 
FROM Connection C1 JOIN Station S1 ON C1.FromStation = S1.Name 
JOIN Station S2 ON C1.ToStation = S2.Name 
WHERE S1.CityName =  'Москва'  AND S2.CityName =  'Тверь';
```
![6](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_2_a.png)

Найдите все многосегментные маршруты, имеющие точно однодневный трансфер 
из Москвы в Санкт-Петербург (первое отправление и прибытие в конечную 
точку должны быть в одну и ту же дату). Вы можете применить функцию DAY () 
к атрибутам Departure и Arrival, чтобы определить дату. 

```
SELECT  DISTINCT C1.TrainNr
FROM Connection C1
JOIN Connection C2 ON C1.ToStation = C2.FromStation
JOIN Station S1 ON C1.FromStation = S1.Name
JOIN Station S2 ON C2.ToStation = S2.Name
WHERE S1.CityName =  'Москва'  
AND S2.CityName =  'Санкт-Петербург'  
AND  DATE(C1.Departure) =  DATE(C2.Arrival);
```

![6](https://github.com/kolpakovee/hse-database/blob/main/images/hw_5_2_b.png)
