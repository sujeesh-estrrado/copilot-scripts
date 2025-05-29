IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Quries]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Quries]
(
    @flag INT,
    @QueryID INT = 0,
    @Councellor_Id INT = 0,
    @Student_Id INT = 0,
    @Type VARCHAR(50) = '''', -- ''C2S'' for councellor to student and ''S2C''
    @Message VARCHAR(MAX) = '''',
    @replyMsg VARCHAR(MAX) = ''''
)
AS
BEGIN
    IF (@flag = 1) -- Insert new Query
    BEGIN
        INSERT INTO Tbl_Quries
        (Councellor_Id, Student_Id, [Type], [Message], [Status], [date])
        VALUES
        (@Councellor_Id, @Student_Id, @Type, @Message, ''UnRead'', GETDATE())
    END
    
    IF (@flag = 2) -- Get a Student''s queries
    BEGIN
        SELECT * FROM Tbl_Quries WHERE Student_Id = @Student_Id
    END
    
    IF (@flag = 3) -- Get a Councellor''s queried students
    BEGIN
        SELECT DISTINCT Student_Id FROM Tbl_Quries WHERE Councellor_Id = @Councellor_Id
    END
    
    IF (@flag = 4) -- Get conversation between Councellor and Student
    BEGIN
        SELECT 
            CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) AS Student, 
            Q.QueryID, 
            Q.Councellor_Id, 
            CASE Q.Type
                WHEN ''C2S'' THEN ''LSBF''
                WHEN ''S2C'' THEN ''Student''
            END AS [Query By],
            Q.Message, 
            Q.Status, 
            Q.Student_Id, 
            Q.date, 
            Q.ReplyMsg, 
            CONCAT(EMP.Employee_FName, '' '', EMP.Employee_LName) + ''-'' + R.role_Name AS Councellor
        FROM dbo.Tbl_Candidate_Personal_Det AS CPD 
        INNER JOIN dbo.Tbl_Quries AS Q ON CPD.Candidate_Id = Q.Student_Id 
        LEFT JOIN dbo.Tbl_Employee AS EMP ON Q.Councellor_Id = EMP.Employee_Id
        LEFT JOIN Tbl_Employee_User EU ON EMP.Employee_Id = EU.Employee_Id 
        LEFT JOIN Tbl_User U ON EU.User_Id = U.user_Id 
        LEFT JOIN tbl_Role R ON R.role_Id = U.role_Id
        WHERE Student_Id = @Student_Id
    END
    
    IF (@flag = 5) -- Status to Read
    BEGIN
        UPDATE Tbl_Quries SET [Status] = ''Read'' WHERE QueryID = @QueryID
    END
    
    IF (@flag = 6) -- Read all councellor queries
    BEGIN
        UPDATE Tbl_Quries 
        SET [Status] = ''Read'' 
        WHERE Councellor_Id = @Councellor_Id AND [Type] = ''S2C''
    END
    
    IF (@flag = 7) -- Read all student queries
    BEGIN
        UPDATE Tbl_Quries 
        SET [Status] = ''Read'' 
        WHERE Student_Id = @Student_Id AND [Type] = ''C2S''
    END
    
    IF (@flag = 8) -- Reply to query
    BEGIN
        UPDATE Tbl_Quries 
        SET ReplyMsg = @replyMsg, 
            [Status] = ''Replied'', 
            replydate = GETDATE() 
        WHERE QueryID = @QueryID
    END
END
');
END;