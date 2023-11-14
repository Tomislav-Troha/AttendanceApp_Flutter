CREATE OR REPLACE FUNCTION User_Select_byEmail(_email varchar)
RETURNS TABLE (userId int, name varchar, surname varchar, email varchar, username varchar, password bytea, addres varchar, salt bytea, RoleID int, roleName varchar, roleDesc varchar)
AS
$$
	SELECT "u".id, "u".name, "u".surname, "u".email, "u".username, "u".password, "u".addres, "u".salt, "ur"."id", "ur"."roleName", "ur"."roleDesc" 
	FROM "User" as "u" LEFT JOIN "UserRole" as "ur" ON ("u"."userRoleID" = "ur"."id")
	WHERE "u".email = _email;
$$
lANGUAGE SQL;