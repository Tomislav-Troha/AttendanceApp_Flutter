CREATE OR REPLACE FUNCTION User_Select_ByEmployee()
RETURNS TABLE (userId int, name varchar, surname varchar, email varchar, roleId int, roleName varchar, roleDesc varchar)
AS
$$
	SELECT "u".id, "u".name, "u".surname, "u".email, "ur"."id", "ur"."roleName", "ur"."roleDesc"
	FROM "User" as "u"
	INNER JOIN "UserRole" as "ur" ON "ur"."id" = "u"."userRoleID"
	WHERE "u"."userRoleID" = 4;
$$
lANGUAGE SQL;