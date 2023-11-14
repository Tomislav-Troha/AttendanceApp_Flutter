DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'salarypackagetype_select' AND pronargs = 1) THEN
        DROP FUNCTION SalaryPackageType_Select();
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION SalaryPackageType_Select()
RETURNS TABLE (salaryPackageID int, salaryPackageName varchar, salaryPackageDescription text)
AS
$$
	SELECT id, "SalaryPackageType"."packageName", description
	FROM   "SalaryPackageType"
$$
lANGUAGE SQL;