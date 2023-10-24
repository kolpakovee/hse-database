# Домашнее задание 4
## Условие задания
1. Создать физические модели - библиотеки из прошлого задания и две модели из скриншотов прошлого задания 
Рекомендуемые сервисы: https://dbdiagram.io
2. Сгенерировать скрипт для создания БД
3. Создать docker-composer файл, в котором будет 3 бд со следующими параметрами: 
- использоваться образ postgres:14.5
- Имя бд, пароль и названия базы данных по шаблону ФАМИЛИЯ_НОМЕРГРУППЫ
- в папке docker/db/config/имя_бд создать конфигурационный файл БД. Узнать где конфигурационный файл лежит в контейнере можно командой psql -U postgres -c 'SHOW config_file'
- Три скрипта sql для создания БД в папке docker/db/scripts/имя_бд. Для каждой бд свой скрипт. Указать на него путь для docker-entrypoint-initdb.d

## Задача 1
**Физические модели:**

Бибилиотека
```
Table reader {
  unique_number int pk
  name varchar
  surname varchar
  adress varchar
  return_date datetime
  date_of_birth datetime
}

Table takes {
  id int pk
  book_copy_number int
  reader_number int
}

Table book {
  sbn int pk
  year date
  name varchar
  author varchar
  number_of_pages int
  publisher_id int
}

Table book_copy {
  copy_number int pk
  book_isbn int
  shelf_position int
  category_id int
}

Table category {
  id int pk
  name varchar
}

Table publisher {
  id int pk
  adress varchar
  name varchar
}

Ref: takes.book_copy_number > book_copy.copy_number
Ref: takes.reader_number > reader.unique_number
Ref: book.publisher_id > publisher.id
Ref: book_copy.category_id > category.id
```

Станция
```
Table station {
  id int pk
  name varchar pk
  city_id int
  number_of_tracks int
}

Table track {
  id int pk
  station_id int
  number int
}

Table city {
  id int pk
  region varchar
  name varchar
}

Table train {
  train_nr int pk
  length int
}

Table departure {
  id int pk
  track_id int
  train_nr int
  start datetime
}

Table arrival {
  id int pk
  track_number int
  track_id int 
  train_nr int
  end datetime
}

Ref: station.city_id > city.id
Ref: track.station_id > station.id
Ref: departure.track_id > track.id
Ref: departure.train_nr > train.train_nr
Ref: arrival.track_id > track.id
Ref: arrival.train_nr > train.train_nr
```

Персонал станции
```
Table station_personell {
  pers_nr int pk
  station_id int
  name varchar
}

Table caregiver {
  id int pk
  station_personell_id int
  qualification varchar
}

Table doctor {
  id int pk
  station_personell_id int
  area int
  rank varchar
}

Table patient {
  patient_nr int pk
  doctor_id int
  name varchar
  disease varchar
  bed_nr int
}

Table station {
  stan_nr int pk
  name varchar
}

Table room {
  room_nr int pk
  stan_nr int
}

Table bed {
  id int pk
  room_nr int
}

Ref: station_personell.station_id > station.stan_nr
Ref: caregiver.station_personell_id > station_personell.pers_nr
Ref: doctor.station_personell_id > station_personell.pers_nr
Ref: patient.doctor_id > doctor.id
Ref: patient.bed_nr > bed.id
Ref: room.stan_nr > station.stan_nr
Ref: bed.room_nr > room.room_nr
```
## Задача 2
Все скрипты находятся в папке [/task4/docker/db/scripts](https://github.com/kolpakovee/hse-database/blob/main/hometasks/task4/docker/db/scripts)
## Задача 3
Файл [docker-compose.yml](https://github.com/kolpakovee/hse-database/blob/main/hometasks/task4/docker-compose.yml)
## Скриншоты баз данных:
![1](https://github.com/kolpakovee/hse-database/blob/main/images/db_4_1.png)
![2](https://github.com/kolpakovee/hse-database/blob/main/images/db_4_2.png)
![3](https://github.com/kolpakovee/hse-database/blob/main/images/db_4_3.png)
![4](https://github.com/kolpakovee/hse-database/blob/main/images/db_4_4.png)
