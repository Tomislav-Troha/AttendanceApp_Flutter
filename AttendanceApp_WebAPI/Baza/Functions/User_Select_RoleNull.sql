CREATE OR REPLACE FUNCTION User_Select_RoleNull()
RETURNS TABLE (userId int, name varchar, surname varchar, email varchar, username varchar, password bytea, addres varchar)
AS
$$
	SELECT "u".id, "u".name, "u".surname, "u".email, "u".username, "u".password, "u".addres 
	FROM "User" as "u"
	WHERE "u"."userRoleID" IS NULL;
$$
lANGUAGE SQL;

