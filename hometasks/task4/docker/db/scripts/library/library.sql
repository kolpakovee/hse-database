CREATE TABLE "reader" (
  "unique_number" int PRIMARY KEY,
  "name" varchar,
  "surname" varchar,
  "adress" varchar,
  "return_date" date,
  "date_of_birth" date
);

CREATE TABLE "takes" (
  "id" int PRIMARY KEY,
  "book_copy_number" int,
  "reader_number" int
);

CREATE TABLE "book" (
  "sbn" int PRIMARY KEY,
  "year" date,
  "name" varchar,
  "author" varchar,
  "number_of_pages" int,
  "publisher_id" int
);

CREATE TABLE "book_copy" (
  "copy_number" int PRIMARY KEY,
  "book_isbn" int,
  "shelf_position" int,
  "category_id" int
);

CREATE TABLE "category" (
  "id" int PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "publisher" (
  "id" int PRIMARY KEY,
  "adress" varchar,
  "name" varchar
);

ALTER TABLE "takes" ADD FOREIGN KEY ("book_copy_number") REFERENCES "book_copy" ("copy_number");

ALTER TABLE "takes" ADD FOREIGN KEY ("reader_number") REFERENCES "reader" ("unique_number");

ALTER TABLE "book" ADD FOREIGN KEY ("publisher_id") REFERENCES "publisher" ("id");

ALTER TABLE "book_copy" ADD FOREIGN KEY ("category_id") REFERENCES "category" ("id");
