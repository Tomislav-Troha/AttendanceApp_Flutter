CREATE OR REPLACE PROCEDURE TrainingDate_Insert
(
	e_timeFrom timestamp with time zone,
	e_timeTo timestamp with time zone,
	e_trainingID int,
	e_trainerID int
)
LANGUAGE SQL
AS $$
	INSERT INTO "TrainingSession"("startDateTime", "endDateTime", "trainingID", "trainerID") VALUES
	(e_timeFrom,
	 e_timeTo,
	 e_trainingID,
	 e_trainerID
	)
$$;
