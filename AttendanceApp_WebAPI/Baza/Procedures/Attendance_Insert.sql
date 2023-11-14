CREATE OR REPLACE PROCEDURE Attendance_Insert
(
	e_attDesc varchar,
	e_type varchar,
	e_trainingId int,
	e_userId int,
	e_trainingDateID int
)
LANGUAGE SQL
AS $$
	INSERT INTO "Attendance" ("attDesc", "type", "trainingID", "userID", "trainingDateID") 
	VALUES (e_attDesc, e_type, e_trainingId, e_userId, e_trainingDateID)
$$;