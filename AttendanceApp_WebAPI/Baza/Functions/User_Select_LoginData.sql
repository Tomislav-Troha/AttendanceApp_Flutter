CREATE OR REPLACE FUNCTION User_Select_LoginData(_email varchar)
RETURNS TABLE (email varchar, username varchar, password bytea, salt bytea, RoleID int, roleName varchar, roleDesc varchar)
AS
$$
	SELECT u."email", u."username", u."password", u."salt", 
		   "ur"."id", "ur"."roleName", "ur"."roleDesc" 
	FROM "User" as "u"
	LEFT JOIN "UserRole" as "ur" ON ("u"."userRoleID" = "ur"."id")
	WHERE email = _email
$$
lANGUAGE SQL;