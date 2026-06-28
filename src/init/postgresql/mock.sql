CREATE TABLE IF NOT EXISTS mock (
    key_1 VARCHAR(50) PRIMARY KEY,
    key_2 INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO mock (key_1, key_2)
VALUES
    ('value1', 1),
    ('value2', 2);
