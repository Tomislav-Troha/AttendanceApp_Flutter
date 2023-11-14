CREATE OR REPLACE PROCEDURE Attendance_Delete
(
	e_id int
)
LANGUAGE SQL
AS $$
	DELETE FROM "Attendance" 
	WHERE id = e_id
$$;
