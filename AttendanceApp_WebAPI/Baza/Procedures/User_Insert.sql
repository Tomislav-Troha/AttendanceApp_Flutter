CREATE OR REPLACE PROCEDURE User_Insert
(
	e_name varchar,
	e_surname varchar,
	e_email varchar,
	e_username varchar,
	e_password bytea,
	e_address varchar,
	e_salt bytea,
	e_userRoleID int
)
LANGUAGE SQL
AS $$
	INSERT INTO "User"(name, surname, email, username, password, address, salt, "userRoleID") VALUES
	(e_name,
	 e_surname, 
	 e_email,
	 e_username,
	 e_password,
	 e_address,
	 e_salt,
	 e_userRoleID
	)
$$;