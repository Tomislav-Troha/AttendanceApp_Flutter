CREATE OR REPLACE FUNCTION User_Select_ByUsername(_username varchar)
RETURNS TABLE (userId int, name varchar, surname varchar, email varchar, username varchar, password bytea, addres varchar, RoleID int, roleName varchar, roleDesc varchar)
AS
$$
	SELECT "u".id, "u".name, "u".surname, "u".email, "u".username, "u".password, "u".addres, "ur"."id", "ur"."roleName", "ur"."roleDesc" 
	FROM "User" as "u" LEFT JOIN "UserRole" as "ur" ON ("u"."userRoleID" = "ur"."id")
	WHERE "u".username = _username;
$$
lANGUAGE SQL;

