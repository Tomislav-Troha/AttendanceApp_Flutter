CREATE OR REPLACE FUNCTION TrainingDate_Select_ForEmployee(_currentDate timestamp with time zone)
RETURNS TABLE (TrainingSessionID int,
			   StartDateTime timestamp with time zone,
			   EndDateTime timestamp with time zone,
			   TrainingID int,
			   Code varchar, 
			   TrainingType varchar,
			   UserID int,
			   Name varchar, 
			   Surname varchar
			  )
AS
$$
	SELECT "td"."id", "td"."startDateTime",
			"td"."endDateTime", "t"."id", "t"."code", "t"."trainingType",
			"u"."id", "u"."name", "u"."surname"
	from "TrainingSession" as "td"
	INNER JOIN "Training" as "t" on "t"."id" = "td"."trainingID"
	INNER JOIN "User" as "u" on "u"."id" = "td"."trainerID"
	WHERE (date("td"."startDateTime") = date(_currentDate) OR _currentDate IS NULL)
$$
lANGUAGE SQL;