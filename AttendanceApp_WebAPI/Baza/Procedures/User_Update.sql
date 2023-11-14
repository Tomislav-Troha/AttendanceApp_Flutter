CREATE OR REPLACE PROCEDURE User_Update(e_id int, e_name varchar, e_surname varchar, e_address varchar)
LANGUAGE SQL
AS $$
	UPDATE "User" SET name = e_name, surname = e_surname, addres = e_address WHERE id = e_id
$$;