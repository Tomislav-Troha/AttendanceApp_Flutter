CREATE OR REPLACE PROCEDURE User_Insert
(
	e_name varchar,
	e_surname varchar,
	e_email varchar,
	e_username varchar,
	e_password bytea,
	e_addres varchar,
	e_salt bytea
)
LANGUAGE SQL
AS $$
	INSERT INTO "User"(name, surname, email, username, password, addres, salt) VALUES
	(e_name,
	 e_surname, 
	 e_email,
	 e_username,
	 e_password,
	 e_addres,
	 e_salt
	)
$$;
