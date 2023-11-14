CREATE OR REPLACE FUNCTION UserRole_Select()
RETURNS TABLE (roleId int, roleName varchar, roleDesc varchar)
AS
$$
	SELECT "id", "roleName", "roleDesc"
	FROM   "UserRole"
$$
lANGUAGE SQL;
