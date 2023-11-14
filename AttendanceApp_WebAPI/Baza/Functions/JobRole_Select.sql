DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'jobrole_select' AND pronargs = 1) THEN
        DROP FUNCTION JobRole_Select();
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION JobRole_Select()
RETURNS TABLE (jobRoleID int, jobRoleName varchar, jobRoleDescription text)
AS
$$
	SELECT id, "JobRole"."roleName", description
	FROM   "JobRole"
$$
lANGUAGE SQL;