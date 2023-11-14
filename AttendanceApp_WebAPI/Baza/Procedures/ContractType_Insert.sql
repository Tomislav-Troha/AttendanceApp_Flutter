CREATE OR REPLACE PROCEDURE ContractType_Insert
(
	e_contractTypeName varchar,
	e_contractTypeDescription text
)
LANGUAGE SQL
AS $$
	INSERT INTO "ContractType"("contractTypeName", "description") VALUES
	(e_contractTypeName,
	 e_contractTypeDescription
	)
$$;