CREATE TABLE Error_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    source VARCHAR,
    message VARCHAR,
    stack_trace VARCHAR,
    additional_info VARCHAR
);
