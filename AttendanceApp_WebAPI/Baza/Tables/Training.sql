CREATE TABLE "Training" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "code" VARCHAR,
  "trainingType" VARCHAR,
  "title" VARCHAR(255),
  "description" TEXT
);