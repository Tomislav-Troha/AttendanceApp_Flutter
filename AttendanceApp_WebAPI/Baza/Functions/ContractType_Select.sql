DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'contracttype_select' AND pronargs = 1) THEN
        DROP FUNCTION ContractType_Select();
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION ContractType_Select()
RETURNS TABLE (contractTypeID int, contractTypeName varchar, contractTypeDescription text)
AS
$$
	SELECT id, "ContractType"."contractTypeName", description
	FROM   "ContractType"
$$
lANGUAGE SQL;