CREATE OR REPLACE FUNCTION Attendance_SelectAll(_userID int)
RETURNS TABLE (ID_attendance int,
			   attDesc varchar,
			   type varchar,
			   ID_training int,
			   code varchar,
			   trainingType varchar,
			   userId int,
			   name varchar,
			   surname varchar,
			   email varchar,
			   username varchar,
			   addres varchar,
			   ID_trainingDate int,
			   dates timestamp with time zone,
			   timeFrom timestamp with time zone,
			   timeTo timestamp with time zone,
			   roleID int,
			   roleName varchar,
			   roleDesc varchar
			  )
AS
$$
	SELECT "at"."id", "at"."attDesc", "at"."type",
		   "t"."id", "t"."code", "t"."TrainingType", "u"."id", 
		   u."name", u."surname", u."email", u."username", u."addres",
		   td."id", td."dates", td."timeFrom", td."timeTo", ur."id", ur."roleName", ur."roleDesc"
	FROM "Attendance" as "at"
	INNER JOIN "Training" as "t" ON "t"."id" = "at"."trainingID"
	INNER JOIN "User" as "u" ON "u"."id" = "at"."userID"
	INNER JOIN "TrainingDate" as "td" ON "td"."id" = "at"."trainingDateID"
	INNER JOIN "UserRole" as "ur" ON ur."id" = u."userRoleID"
	WHERE (u."id" = _userID OR _userID IS NULL);
$$
lANGUAGE SQL;