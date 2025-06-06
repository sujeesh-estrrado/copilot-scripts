IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Docket_Clerance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Docket_Clerance]
        @flag BIGINT = 0,
        @Skip_Id BIGINT = 0,
        @Docket_Id BIGINT = 0,
        @Student_Id BIGINT = 0,
        @Student_Remarks VARCHAR(MAX) = '''',
        @Approval_Remarks VARCHAR(MAX) = '''',
        @Approved_By BIGINT = 0,
        @Request_date DATETIME = NULL,
        @Approved_date DATETIME = NULL,
        @Approval_status BIGINT = 0,
        @Request_Id BIGINT = 0
        AS
        BEGIN
            IF (@flag = 1) -- Insert request
            BEGIN
                IF NOT EXISTS (
                    SELECT * 
                    FROM Tbl_Skip_Docket 
                    WHERE Student_Id = @Student_Id 
                    AND Request_Id = @Request_Id 
                    AND (Approval_status = 1 OR Approval_status = 2) 
                    AND Delete_Status = 0
                )
                BEGIN
                    INSERT INTO [dbo].[Tbl_Skip_Docket]
                        (Docket_Id, Student_Id, Student_Remarks, Request_date, Request_Id, Created_Date, Delete_Status)
                    VALUES 
                        (@Docket_Id, @Student_Id, @Student_Remarks, GETDATE(), @Request_Id, GETDATE(), 0)

                    RETURN SCOPE_IDENTITY()
                END
            END

            IF (@flag = 2) -- Approve / Reject request
            BEGIN
                UPDATE Tbl_Skip_Docket 
                SET 
                    Approval_Remarks = @Approval_Remarks,
                    Approved_By = @Approved_By,
                    Approval_status = @Approval_status,
                    Approved_date = GETDATE(),
                    Updated_Date = GETDATE()
                WHERE 
                    Student_Id = @Student_Id 
                    AND Request_Id = @Request_Id  
                    AND Delete_Status = 0
            END

            IF (@flag = 3) -- Fetch details
            BEGIN
                SELECT 
                    ED.Docket_number,
                    CONVERT(VARCHAR(50), SD.Request_date, 103) AS Request_date,
                    SD.Request_Id,
                    SD.Docket_Id,
                    Approval_Remarks,
                    Student_Remarks,
                    Approval_status
                FROM Tbl_Skip_Docket SD
                INNER JOIN Tbl_ExamDocket ED ON ED.Docket_Id = SD.Docket_Id
                WHERE 
                    SD.Student_Id = @Student_Id 
                    AND SD.Request_Id = @Request_Id
            END
        END
    ')
END
