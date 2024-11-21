CREATE OR REPLACE FUNCTION User_CheckIfFirstEver()
RETURNS TABLE (userExists boolean)
AS
$$
BEGIN

    IF EXISTS (SELECT 1 FROM "User") THEN
        RETURN QUERY SELECT false;
    ELSE
        RETURN QUERY SELECT true;
    END IF;
END;
$$
LANGUAGE plpgsql;