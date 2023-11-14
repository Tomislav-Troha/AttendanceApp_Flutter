CREATE OR REPLACE PROCEDURE Log_Insert
(
	_source varchar,
	_message varchar,
	_stack_trace varchar,
	_additional_info varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO "error_logs" ("source", "message", "stack_trace", "additional_info")
	VALUES (_source, _message, _stack_trace, _additional_info);
END;
$$;
