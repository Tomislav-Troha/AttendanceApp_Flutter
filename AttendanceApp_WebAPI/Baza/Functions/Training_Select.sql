CREATE OR REPLACE FUNCTION Training_Select(_id int)
RETURNS TABLE (id_training int, code varchar, trainingtype varchar)
AS
$$
	SELECT id, code, "Training"."trainingtype"
	FROM   "Training"
	WHERE (id = _id OR _id IS NULL );
$$
lANGUAGE SQL;