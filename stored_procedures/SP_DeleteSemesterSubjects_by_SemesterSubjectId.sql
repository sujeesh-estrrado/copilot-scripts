IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteSemesterSubjects_by_SemesterSubjectId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DeleteSemesterSubjects_by_SemesterSubjectId]  
        (@Semester_Subject_Id bigint)    
        AS    
        BEGIN
            BEGIN TRY    
                DELETE FROM Tbl_Semester_Subjects   
                WHERE Semester_Subject_Id = @Semester_Subject_Id  
            END TRY
            BEGIN CATCH
                RAISERROR(''Cannot be deleted'', 16, 1)
            END CATCH
        END
    ')
END
