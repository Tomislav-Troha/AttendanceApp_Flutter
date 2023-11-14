CREATE OR REPLACE PROCEDURE JobRole_Insert
(
	e_jobRoleName varchar,
	e_jobRoleDescription text
)
LANGUAGE SQL
AS $$
	INSERT INTO "JobRole"("roleName", "description") VALUES
	(e_jobRoleName,
	 e_jobRoleDescription
	)
$$;