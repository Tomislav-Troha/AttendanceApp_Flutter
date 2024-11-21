CREATE OR REPLACE FUNCTION TrainingSession_Select(_userID int, _currentDate timestamp with time zone)
RETURNS TABLE 
(
	TrainingSessionID int,
	StartDateTime timestamp with time zone,
	EndDateTime timestamp with time zone,
	TrainingID int,
	Code varchar,
	TrainingType varchar,
	UserID int,
	Name varchar,
	Surname varchar,
	Email varchar,
	Username varchar,
	Address varchar,
	RoleId int,
	UserRoleName varchar,
	UserRoleDescription varchar
)
AS
$$
	SELECT td."id", td."startDateTime", td."endDateTime",
		   "t"."id", "t"."code", "t"."trainingType", "u"."id", u."name", u."surname", u."email", u."username",
		   u."address", ur."id", ur."name", ur."description"
	FROM   "TrainingSession" as "td"
	INNER JOIN "Training" as "t" ON "t"."id" = "td"."trainingID"
	INNER JOIN "User" as "u" ON "u"."id" = "td"."trainerID"
	INNER JOIN "UserRole" as "ur" ON "ur"."id" = u."userRoleID"
	WHERE u."id" = _userID AND (DATE(td."startDateTime") = DATE(_currentDate) OR _currentDate IS NULL);
$$
lANGUAGE SQL;