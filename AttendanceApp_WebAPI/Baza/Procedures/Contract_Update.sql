DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'contract_update' AND pronargs = 1) THEN
        DROP PROCEDURE Contract_Update;
    END IF;
END
$$;

CREATE OR REPLACE PROCEDURE Contract_Update(
    p_id int,
    p_contractTypeId int,
    p_salaryPackageId int,
    p_jobRoleId int,
    p_startDate timestamp with time zone,
    p_expiryDate timestamp with time zone
)
LANGUAGE SQL
AS $$
 UPDATE "Contract" 
    SET 
        "contractTypeID" = p_contractTypeId,
        "salaryPackageID" = p_salaryPackageId,
        "jobRoleID" = p_jobRoleId,
        "startDate" = p_startDate,
        "expiryDate" = p_expiryDate
    WHERE 
        "id" = p_id;
$$;

