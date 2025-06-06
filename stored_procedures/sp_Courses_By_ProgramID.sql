IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Courses_By_ProgramID]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Courses_By_ProgramID] 
        @ProgramId INT
        AS
        BEGIN
            SELECT        
                DS.Department_Subject_Id, 
                D.Department_Id AS Course_Department_Id, 
                DS.Subject_Id, 
                D.Department_Name AS [Department Name]
            FROM dbo.Tbl_Department_Subjects AS DS 
            INNER JOIN dbo.Tbl_Department AS D ON DS.Course_Department_Id = D.Department_Id
            WHERE (D.Department_Id = @ProgramId OR @ProgramId IS NULL)
        END
    ')
END
