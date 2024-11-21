CREATE OR REPLACE FUNCTION TrainingSession_Insert(
    e_startDateTime timestamp with time zone,
    e_endDateTime timestamp with time zone,
    e_trainingID int,
    e_trainerID int
)
RETURNS TABLE 
(
    TrainingSessionID int,
    StartDateTime timestamp with time zone,
    EndDateTime timestamp with time zone,
    TrainingID int,
    Code varchar,
    TrainingType varchar,
    UserId int,
    Name varchar,
    Surname varchar,
    Email varchar,
    Username varchar,
    Address varchar
)
AS $$
BEGIN
    INSERT INTO "TrainingDate"("startDateTime", "endDateTime", "trainingID", "trainerID")
    VALUES (e_timeFrom, e_timeTo, e_trainingID, e_trainerID);

    RETURN QUERY
	SELECT td."id", td."startDateTime", td."endDateTime",
		   t."id", t."code", t."trainingtype", u."id", u."name", u."surname", u."email", u."username",
		   u."addres"
	FROM "TrainingSession" as td
	INNER JOIN "Training" as t ON t."id" = td."trainingID"
	INNER JOIN "User" as u ON u."id" = td."userID"
	WHERE td."id" = currval(pg_get_serial_sequence('"TrainingSession"', 'id'));

END;
$$ LANGUAGE plpgsql;
