CREATE OR REPLACE PROCEDURE User_SetProfileImage
(
	e_id int,
	e_profileImage bytea
)
LANGUAGE SQL
AS $$
	UPDATE "User" SET "profileImage" = e_profileImage WHERE id = e_id
$$;
