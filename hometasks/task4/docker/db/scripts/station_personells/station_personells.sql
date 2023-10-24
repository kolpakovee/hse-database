CREATE TABLE "station_personell" (
  "pers_nr" int PRIMARY KEY,
  "station_id" int,
  "name" varchar
);

CREATE TABLE "caregiver" (
  "id" int PRIMARY KEY,
  "station_personell_id" int,
  "qualification" varchar
);

CREATE TABLE "doctor" (
  "id" int PRIMARY KEY,
  "station_personell_id" int,
  "area" int,
  "rank" varchar
);

CREATE TABLE "patient" (
  "patient_nr" int PRIMARY KEY,
  "doctor_id" int,
  "name" varchar,
  "disease" varchar,
  "bed_nr" int
);

CREATE TABLE "station" (
  "stan_nr" int PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "room" (
  "room_nr" int PRIMARY KEY,
  "stan_nr" int
);

CREATE TABLE "bed" (
  "id" int PRIMARY KEY,
  "room_nr" int
);

ALTER TABLE "station_personell" ADD FOREIGN KEY ("station_id") REFERENCES "station" ("stan_nr");

ALTER TABLE "caregiver" ADD FOREIGN KEY ("station_personell_id") REFERENCES "station_personell" ("pers_nr");

ALTER TABLE "doctor" ADD FOREIGN KEY ("station_personell_id") REFERENCES "station_personell" ("pers_nr");

ALTER TABLE "patient" ADD FOREIGN KEY ("doctor_id") REFERENCES "doctor" ("id");

ALTER TABLE "patient" ADD FOREIGN KEY ("bed_nr") REFERENCES "bed" ("id");

ALTER TABLE "room" ADD FOREIGN KEY ("stan_nr") REFERENCES "station" ("stan_nr");

ALTER TABLE "bed" ADD FOREIGN KEY ("room_nr") REFERENCES "room" ("room_nr");
