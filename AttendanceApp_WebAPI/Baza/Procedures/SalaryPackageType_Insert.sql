CREATE OR REPLACE PROCEDURE SalaryPackageType_Insert
(
	e_salaryPackageName varchar,
	e_salaryPackageDescription text
)
LANGUAGE SQL
AS $$
	INSERT INTO "SalaryPackageType"("packageName", "description") VALUES
	(e_salaryPackageName,
	 e_salaryPackageDescription
	)
$$;