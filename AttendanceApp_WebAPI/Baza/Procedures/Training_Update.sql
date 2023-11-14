CREATE OR REPLACE PROCEDURE Training_Update
(
	e_id int,
	e_code varchar,
	e_trainingType varchar
)
LANGUAGE SQL
AS $$
	UPDATE "Training" SET code = e_code, "TrainingType" = e_trainingType WHERE id = e_id
$$;