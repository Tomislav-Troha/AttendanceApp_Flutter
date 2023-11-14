CREATE OR REPLACE PROCEDURE User_Delete
(
	e_id int
)
LANGUAGE SQL
AS $$
	
	DELETE FROM "TrainingDate" where "userID" = e_id;

	DELETE FROM "User" 
	WHERE id = e_id
$$;
