CREATE OR REPLACE PROCEDURE User_SetRole
(
	e_id int,
	e_userRoleID int
)
LANGUAGE SQL
AS $$
	UPDATE "User" SET "userRoleID" = e_userRoleID WHERE id = e_id
$$;
