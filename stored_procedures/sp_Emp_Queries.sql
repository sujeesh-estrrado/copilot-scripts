IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Emp_Queries]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Emp_Queries]
            @flag INT,
            @QueryID INT = 0,
            @Employee_Id INT = 0,
            @Type VARCHAR(50) = '''', -- ''C2S'' for counselor to student and ''S2C''
            @Message VARCHAR(MAX) = '''',
            @replyMsg VARCHAR(MAX) = '''',
            @repliedby BIGINT = NULL
        AS
        BEGIN    
            IF (@flag = 1) -- Insert new Query
            BEGIN
                INSERT INTO Tbl_Emp_Queries
                ([Employee_Id], Type, [Message], [Status], [date], [Councellor_Id])
                VALUES
                (@Employee_Id, @Type, @Message, ''UnRead'', GETDATE(), @repliedby)
            END
            IF (@flag = 2) -- Get a Student''s queries
            BEGIN
                SELECT * FROM Tbl_Emp_Queries WHERE Employee_Id = @Employee_Id
            END
            IF (@flag = 3) -- Get a Counselor''s queried students
            BEGIN
                SELECT DISTINCT Employee_Id FROM Tbl_Emp_Queries
            END
            IF (@flag = 4) -- Get a conversation between a Counselor and a Student
            BEGIN
                SELECT 
                    CONCAT(CPD.Employee_FName, '' '', CPD.Employee_LName) AS Student,
                    Q.Query_Id, 
                    (CASE Q.Type
                        WHEN ''C2S'' THEN ''LSBF''
                        WHEN ''S2C'' THEN ''Student''
                    END) AS [Query By],
                    Q.Message, 
                    Q.Status, 
                    Q.Employee_Id, 
                    Q.date, 
                    Q.ReplyMsg
                FROM 
                    dbo.Tbl_Employee AS CPD 
                INNER JOIN
                    dbo.Tbl_Emp_Queries AS Q ON CPD.Employee_Id = Q.Employee_Id 
                WHERE 
                    Q.Employee_Id = @Employee_Id
            END
            IF (@flag = 5) -- Status to Read
            BEGIN
                UPDATE Tbl_Emp_Queries 
                SET [Status] = ''Read'' 
                WHERE Query_Id = @QueryID
            END
            IF (@flag = 6) -- Read all counselor queries
            BEGIN
                UPDATE Tbl_Emp_Queries 
                SET [Status] = ''Read'' 
                WHERE [Type] = ''S2C''
            END
            IF (@flag = 7) -- Read all student queries
            BEGIN
                UPDATE Tbl_Emp_Queries 
                SET [Status] = ''Read'' 
                WHERE Employee_Id = @Employee_Id AND [Type] = ''C2S''
            END
            IF (@flag = 8) -- Reply to query
            BEGIN
                UPDATE Tbl_Emp_Queries 
                SET ReplyMsg = @replyMsg, [Status] = ''Replied'', replydate = GETDATE() 
                WHERE Query_Id = @QueryID
            END
        END
    ')
END
