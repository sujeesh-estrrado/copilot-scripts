IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Load_ExamType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Load_ExamType]
        AS
        BEGIN
            SELECT * 
            FROM Tbl_Course_Duration_Mapping
            WHERE Course_Department_Status = 0
        END
    ')
END
