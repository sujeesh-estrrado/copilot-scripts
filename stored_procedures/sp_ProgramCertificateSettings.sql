IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ProgramCertificateSettings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_ProgramCertificateSettings]
(
    @flag BIGINT = 0,
    @id BIGINT = 0,
    @Student_type VARCHAR(50) = '''',
    @Department_id BIGINT = 0,
    @English_Test_Status BIT = 0,
    @Work_Experience_status BIT = 0,
    @Research_status BIT = 0,
    @Annual_practice BIT = 0,
    @Createdate DATETIME = NULL,
    @Delete_status BIT = 0
)
AS
BEGIN
    IF (@flag = 1) -- Insert
    BEGIN 
        IF NOT EXISTS (
            SELECT * FROM [Tbl_ProgramCertificateSettings] 
            WHERE [Student_type] = @Student_type 
            AND Department_id = @Department_id  
            AND delete_status = 0
        )
        BEGIN
            INSERT INTO [dbo].[Tbl_ProgramCertificateSettings]
            (
                [Student_type],
                [Department_id],
                [English_Test_Status],
                [Work_Experience_status],
                [Research_status],
                [Annual_practice],
                [Createdate],
                [Delete_status]
            )
            VALUES
            (
                @Student_type,
                @Department_id,
                0,
                0,
                0,
                0,
                GETDATE(),
                0
            )
        END
    END
    
    IF (@flag = 2) -- Get
    BEGIN
        SELECT 
            PCS.id, 
            PCS.Student_type, 
            PCS.Department_id, 
            PCS.English_Test_Status, 
            PCS.Work_Experience_status, 
            PCS.Research_status,
            PCS.Annual_practice, 
            PCS.Createdate, 
            PCS.Delete_status, 
            CONCAT(Dept.Department_Name, ''-'', Dept.Course_Code) AS Program
        FROM dbo.Tbl_ProgramCertificateSettings AS PCS 
        INNER JOIN dbo.Tbl_Department AS Dept 
            ON PCS.Department_id = Dept.Department_Id
        WHERE (PCS.Student_type = @Student_type OR @Student_type = '''') 
          AND (PCS.Department_id = @Department_id OR @Department_id = 0) 
          AND (PCS.Delete_status = 0) 
        ORDER BY Dept.Department_Name
    END
    
    IF (@flag = 3) -- Update
    BEGIN
        UPDATE Tbl_ProgramCertificateSettings
        SET 
            [English_Test_Status] = @English_Test_Status,
            [Work_Experience_status] = @Work_Experience_status,
            [Research_status] = @Research_status,
            [Annual_practice] = @Annual_practice,
            [Createdate] = GETDATE()
        WHERE [Student_type] = @Student_type 
          AND [Department_id] = @Department_id  
          AND delete_status = 0
    END
END
');
END;