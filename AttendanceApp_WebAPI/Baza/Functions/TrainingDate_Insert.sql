CREATE OR REPLACE FUNCTION TrainingDate_Insert(
    e_dates timestamp with time zone,
    e_timeFrom timestamp with time zone,
    e_timeTo timestamp with time zone,
    e_trainingID int,
    e_userID int
)
RETURNS TABLE 
(
    ID_TrainingDate int,
    dates timestamp with time zone,
    timeFrom timestamp with time zone,
    timeTo timestamp with time zone,
    ID_training int,
    code varchar,
    trainingType varchar,
    userId int,
    name varchar,
    surname varchar,
    email varchar,
    username varchar,
    address varchar
)
AS $$
BEGIN
    INSERT INTO "TrainingDate"("dates", "timefrom", "timeto", "trainingID", "userID")
    VALUES (e_dates, e_timeFrom, e_timeTo, e_trainingID, e_userID);

    RETURN QUERY
	SELECT td."id", td."dates", td."timefrom", td."timeto",
		   t."id", t."code", t."trainingtype", u."id", u."name", u."surname", u."email", u."username",
		   u."addres"
	FROM "TrainingDate" as td
	INNER JOIN "Training" as t ON t."id" = td."trainingID"
	INNER JOIN "User" as u ON u."id" = td."userID"
	WHERE td."id" = currval(pg_get_serial_sequence('"TrainingDate"', 'id'));

END;
$$ LANGUAGE plpgsql;
