CREATE OR REPLACE PROCEDURE TrainingDate_Insert
(
	e_dates timestamp with time zone,
	e_timeFrom timestamp with time zone,
	e_timeTo timestamp with time zone,
	e_trainingID int,
	e_userID int
)
LANGUAGE SQL
AS $$
	INSERT INTO "TrainingDate"("dates", "timeFrom", "timeTo", "trainingID", "userID") VALUES
	(e_dates,
	 e_timeFrom,
	 e_timeTo,
	 e_trainingID,
	 e_userID
	)
$$;
