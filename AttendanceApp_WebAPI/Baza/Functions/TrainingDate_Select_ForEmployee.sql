CREATE OR REPLACE FUNCTION TrainingDate_Select_ForEmployee(_currentDate timestamp with time zone)
RETURNS TABLE (ID_TrainingDate int,
			   dates timestamp with time zone,
			   timeFrom timestamp with time zone,
			   timeTo timestamp with time zone,
			   id_training int,
			   code varchar, 
			   trainingType varchar,
			   userID int,
			   name varchar, 
			   surname varchar
			  )
AS
$$
	SELECT "td"."id", "td"."dates", "td"."timeFrom",
			"td"."timeTo", "t"."id", "t"."code", "t"."TrainingType",
			"u"."id", "u"."name", "u"."surname"
	from "TrainingDate" as "td"
	INNER JOIN "Training" as "t" on "t"."id" = "td"."trainingID"
	INNER JOIN "User" as "u" on "u"."id" = "td"."userID"
	WHERE (date("td".dates) = date(_currentDate) OR _currentDate IS NULL)
$$
lANGUAGE SQL;