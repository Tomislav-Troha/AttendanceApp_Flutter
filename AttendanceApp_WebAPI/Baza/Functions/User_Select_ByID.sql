CREATE OR REPLACE FUNCTION User_Select_ByID(_id int)
RETURNS TABLE (userId int,
			   name varchar,
			   surname varchar,
			   email varchar,
			   username varchar,
			   password bytea,
			   salt  bytea,
			   addres varchar,
			   profileImage bytea,
			   roleID int,
			   roleName varchar,
			   roleDesc varchar
			  )
AS
$$
	SELECT "u".id, "u".name, "u".surname, "u".email, "u".username,
		   "u".password, u."salt", "u".addres, "u"."profileImage", "ur"."id", "ur"."roleName", "ur"."roleDesc" 
	FROM "User" as "u" LEFT JOIN "UserRole" as "ur" ON ("u"."userRoleID" = "ur"."id")
	WHERE "u"."id" = _id;
$$
lANGUAGE SQL;