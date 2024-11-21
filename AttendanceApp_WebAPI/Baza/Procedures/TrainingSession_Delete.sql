CREATE OR REPLACE PROCEDURE TrainingSession_Delete
(
	e_id int
)
LANGUAGE SQL
AS $$
	DELETE FROM "TrainingSession" 
	WHERE id = e_id
$$;
