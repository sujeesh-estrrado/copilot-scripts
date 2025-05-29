IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_PgmCode_Intake_SemExam]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Get_PgmCode_Intake_SemExam]
    @Department_Id BIGINT,
    @batch_id BIGINT,
    @Sem_Id BIGINT
AS
BEGIN
    SELECT 
        (SELECT Course_Code 
         FROM Tbl_Department 
         WHERE Department_Id = @Department_Id) AS Program_Code,
         
        (SELECT LEFT(REPLACE(Batch_Code, ''/'', ''''), 6) 
         FROM Tbl_Course_Batch_Duration 
         WHERE Batch_Id = @batch_id) AS Short_Batch_Code,
         
        (SELECT Semester_Id 
         FROM Tbl_Course_Semester 
         WHERE Semester_Id = @Sem_Id) AS Semester_Id;
END
    ')
END;
