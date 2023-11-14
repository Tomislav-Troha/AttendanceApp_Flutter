CREATE OR REPLACE PROCEDURE TrainingDate_Delete
(
	e_id int
)
LANGUAGE SQL
AS $$
	DELETE FROM "TrainingDate" 
	WHERE id = e_id
$$;
