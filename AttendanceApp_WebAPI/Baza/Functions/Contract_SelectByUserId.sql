DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'contract_selectbyuserid' AND pronargs = 1) THEN
        DROP FUNCTION Contract_SelectByUserId(INT);
    END IF;
END
$$;

CREATE FUNCTION Contract_SelectByUserId(_userId INT)
RETURNS TABLE(
    employeeContractID INT,
    startDate timestamp with time zone,
    expiryDate timestamp with time zone,
    userId INT,
    roleId INT,
    roleName varchar,
    roleDesc varchar,
    contractTypeId INT,
    contractTypeName varchar,
    contractTypeDescription varchar,
    salaryPackageId INT,
    salaryPackageName varchar,
    salaryPackageDescription text,
    jobRoleId INT,
    jobRoleName varchar,
    jobRoleDescription text
)
AS
$$
    SELECT 
      ec."id",
      ec."startDate",
      ec."expiryDate",
	  --user
	  u.id,
      --userRole
      ur."id",
      ur."roleName",
      ur."roleDesc",
      --Contract Type
      ct."id",
      ct."contractTypeName",
      ct."description",
      --SalaryPackage
      sp."id",
      sp."packageName",
      sp."description",
      --JobRole
      jr."id",
      jr."roleName",
      jr."description"
    FROM "Contract" ec
    LEFT JOIN "UserRole" ur ON ec."userRoleID" = ur."id"
	LEFT JOIN "User" u on u."id" = ec."userId"
    LEFT JOIN "ContractType" ct ON ec."contractTypeID" = ct."id"
    LEFT JOIN "SalaryPackageType" sp ON ec."salaryPackageID" = sp."id"
    LEFT JOIN "JobRole" jr ON ec."jobRoleID" = jr."id"
    WHERE ("ec"."userId" = _userId) OR (_userId IS NULL);
$$
LANGUAGE SQL;
