CREATE OR REPLACE PROCEDURE User_UpdatePassword(e_email varchar, e_salt bytea, e_password bytea)
LANGUAGE SQL
AS $$
	UPDATE "User" SET password = e_password, salt = e_salt WHERE email = e_email
$$;