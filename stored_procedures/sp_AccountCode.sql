IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_AccountCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_AccountCode]
        (
            @flag INT = 0,
            @id BIGINT = 0,
            @code VARCHAR(60) = '''',
            @name VARCHAR(300) = '''',
            @description VARCHAR(765) = '''',
            @odr INT = 0,
            @active INT = 1,
            @flagledger CHAR(1) = '''',
            @taxcode_id CHAR(1) = '''',
            @sales BIT = 0
        )
        AS
        BEGIN
            IF @flag = 1 -- Add Account Code
            BEGIN
                IF (SELECT COUNT(code) FROM ref_accountcode WHERE (code = @code) AND (deleteStatus = 0)) <= 1
                BEGIN
                    INSERT INTO ref_accountcode 
                    ([code], [name], [description], [odr], [active], [flagledger], [taxcode_id], deleteStatus, createdDate, updatedDate, [sales]) 
                    VALUES 
                    (@code, @name, @description, @odr, @active, @flagledger, @taxcode_id, 0, GETDATE(), GETDATE(), @sales)
                END
            END
            
            IF @flag = 2 -- Get All Account Code
            BEGIN
                SELECT 
                    [id] AS AccountCode_Id,
                    [code] AS AccountCode,
                    [name] AS AccountCodeName,
                    [description],
                    [odr],
                    [active],
                    [flagledger],
                    CASE 
                        WHEN taxcode_id = 1 THEN ''S'' 
                        WHEN taxcode_id = 2 THEN ''E'' 
                        WHEN taxcode_id = 3 THEN ''Z'' 
                    END AS [taxcode_id],
                    [deleteStatus],
                    [createdDate],
                    [updatedDate],
                    [sales]
                FROM [dbo].[ref_accountcode]
                WHERE 
                    ([deleteStatus] = 0) 
                    AND ([active] = @active OR @active = 2) 
                    AND (flagledger = @flagledger OR @flagledger = ''A'')
                ORDER BY [name]
            END

            IF @flag = 3 -- Get Code Count
            BEGIN
                SELECT COUNT(code) AS CodeCount  
                FROM ref_accountcode 
                WHERE (code = @code) AND (deleteStatus = 0)
            END

            IF @flag = 4 -- Get odr Count
            BEGIN
                SELECT 
                    (SELECT COUNT([odr]) FROM ref_accountcode WHERE (odr = @odr) AND (deleteStatus = 0) AND ((id <> @id) OR (@id = 0))) AS OdrCount,
                    (SELECT COUNT(code) FROM ref_accountcode WHERE (code = @code) AND (deleteStatus = 0) AND ((id <> @id) OR (@id = 0))) AS CodeCount,
                    (SELECT COUNT(name) FROM ref_accountcode WHERE (name = @name) AND (deleteStatus = 0) AND ((id <> @id) OR (@id = 0))) AS NameCount
            END

            IF @flag = 5 -- Update Active Status
            BEGIN
                UPDATE ref_accountcode 
                SET [active] = @active 
                WHERE id = @id
            END

            IF @flag = 6 -- Get Account Code using id
            BEGIN
                SELECT 
                    [id] AS AccountCode_Id,
                    [code] AS AccountCode,
                    [name] AS AccountCodeName,
                    [description],
                    [odr],
                    [active],
                    [flagledger],
                    [taxcode_id],
                    [deleteStatus],
                    [createdDate],
                    [updatedDate],
                    [sales]
                FROM [dbo].[ref_accountcode]
                WHERE 
                    ([deleteStatus] = 0) 
                    AND ([id] = @id)
            END

            IF @flag = 7 -- Update Table ref_accountcode
            BEGIN
                UPDATE ref_accountcode 
                SET 
                    [code] = @code, 
                    name = @name, 
                    [description] = @description, 
                    [active] = @active,
                    [flagledger] = @flagledger,
                    [odr] = @odr, 
                    [taxcode_id] = @taxcode_id, 
                    [sales] = @sales  
                WHERE id = @id
            END

            IF @flag = 8 -- Delete ref_accountcode
            BEGIN
                IF ((SELECT COUNT(accountcodeid) FROM fee_group_item WHERE (accountcodeid = @id) AND deleteStatus = 0) <= 0)
                BEGIN
                    UPDATE ref_accountcode 
                    SET deleteStatus = 1 
                    WHERE id = @id
                END
            END

            IF @flag = 9 -- Get Account Code using Code
            BEGIN
                SELECT 
                    [id] AS AccountCode_Id,
                    [code] AS AccountCode,
                    [name] AS AccountCodeName,
                    [description],
                    [odr],
                    [active],
                    [flagledger],
                    [taxcode_id],
                    [deleteStatus],
                    [createdDate],
                    [updatedDate],
                    [sales]
                FROM [dbo].[ref_accountcode]
                WHERE 
                    ([deleteStatus] = 0) 
                    AND ([code] = @code)
            END

            IF @flag = 10 -- Get Active Account Code
            BEGIN
                SELECT 
                    [id] AS AccountCode_Id,
                    [code] AS AccountCode,
                    [name] AS AccountCodeName,
                    [description],
                    [odr],
                    [active],
                    [flagledger],
                    CASE 
                        WHEN taxcode_id = 1 THEN ''S'' 
                        WHEN taxcode_id = 2 THEN ''E'' 
                        WHEN taxcode_id = 3 THEN ''Z'' 
                    END AS [taxcode_id],
                    [deleteStatus],
                    [createdDate],
                    [updatedDate],
                    [sales]
                FROM [dbo].[ref_accountcode]
                WHERE 
                    ([deleteStatus] = 0) 
                    AND ([active] = 1)
                ORDER BY [name]
            END
        END
    ')
END
