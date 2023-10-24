CREATE TABLE "station" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "city_id" int,
  "number_of_tracks" int
);

CREATE TABLE "track" (
  "id" int PRIMARY KEY,
  "station_id" int,
  "number" int
);

CREATE TABLE "city" (
  "id" int PRIMARY KEY,
  "region" varchar,
  "name" varchar
);

CREATE TABLE "train" (
  "train_nr" int PRIMARY KEY,
  "length" int
);

CREATE TABLE "departure" (
  "id" int PRIMARY KEY,
  "track_id" int,
  "train_nr" int,
  "start" date
);

CREATE TABLE "arrival" (
  "id" int PRIMARY KEY,
  "track_number" int,
  "track_id" int,
  "train_nr" int,
  "end" date
);

ALTER TABLE "station" ADD FOREIGN KEY ("city_id") REFERENCES "city" ("id");

ALTER TABLE "track" ADD FOREIGN KEY ("station_id") REFERENCES "station" ("id");

ALTER TABLE "departure" ADD FOREIGN KEY ("track_id") REFERENCES "track" ("id");

ALTER TABLE "departure" ADD FOREIGN KEY ("train_nr") REFERENCES "train" ("train_nr");

ALTER TABLE "arrival" ADD FOREIGN KEY ("track_id") REFERENCES "track" ("id");

ALTER TABLE "arrival" ADD FOREIGN KEY ("train_nr") REFERENCES "train" ("train_nr");
