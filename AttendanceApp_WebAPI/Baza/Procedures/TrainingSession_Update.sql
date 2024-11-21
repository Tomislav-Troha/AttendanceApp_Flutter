CREATE OR REPLACE PROCEDURE TrainingDate_Update
(
	e_id int,
	e_timeFrom timestamp with time zone,
	e_timeTo timestamp with time zone,
	e_trainingID int,
	e_trainerID int
)
LANGUAGE SQL
AS $$
	UPDATE "TrainingSession" SET "startDateTime" = e_timeFrom, "endDateTime" = e_timeTo, "trainingID" = e_trainingID, "trainerID" = e_trainerID
	WHERE id = e_id
$$;
