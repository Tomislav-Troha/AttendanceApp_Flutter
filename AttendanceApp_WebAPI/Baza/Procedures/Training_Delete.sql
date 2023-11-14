CREATE OR REPLACE PROCEDURE Training_Delete
(
	e_id int
)
LANGUAGE SQL
AS $$
	DELETE FROM "Training" WHERE id = e_id
$$;
