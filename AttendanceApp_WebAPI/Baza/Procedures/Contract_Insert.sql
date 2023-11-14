CREATE OR REPLACE PROCEDURE Contract_Insert(
    p_userID INT,
    p_userRoleID INT,
    p_contractTypeID INT = null,
    p_salaryPackageID INT = null,
    p_jobRoleID INT = null,
    p_startDate timestamp with time zone = null,
    p_expiryDate timestamp with time zone = null
)
LANGUAGE SQL
AS $$
    INSERT INTO "Contract" ("userId", "userRoleID", "contractTypeID", "salaryPackageID", "jobRoleID", "startDate", "expiryDate")
    VALUES (p_userID, p_userRoleID, p_contractTypeID, p_salaryPackageID, p_jobRoleID, p_startDate, p_expiryDate);
	
	UPDATE "User" SET "userRoleID" = p_userRoleID WHERE id = p_userID
$$;