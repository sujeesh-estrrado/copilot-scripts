
IF NOT EXISTS (SELECT * FROM sys.types WHERE name = 'keyvalue_table' AND is_table_type = 1)
BEGIN
    CREATE TYPE keyvalue_table AS TABLE
    (
        [key] NVARCHAR(255),
        [value] NVARCHAR(MAX)
    );
END;