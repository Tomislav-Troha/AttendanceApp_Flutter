CREATE OR REPLACE PROCEDURE TrainingDate_Update
(
	e_id int,
	e_dates timestamp with time zone,
	e_timeFrom timestamp with time zone,
	e_timeTo timestamp with time zone,
	e_trainingID int
)
LANGUAGE SQL
AS $$
	UPDATE "TrainingDate" SET dates = e_dates, "timeFrom" = e_timeFrom, "timeTo" = e_timeTo,
						      "trainingID" = e_trainingID
	WHERE id = e_id
$$;
