IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_StudentsinBatch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_StudentsinBatch] 
        @Batch_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT DISTINCT 
                CPD.Candidate_Id,  
                CPD.Candidate_Fname + '' '' + 
                ISNULL(CPD.Candidate_Mname, '''') + '' '' + 
                CPD.Candidate_Lname AS CandidateName       
            FROM dbo.Tbl_Semester_Subjects SS       
            INNER JOIN dbo.Tbl_Department_Subjects DS 
                ON DS.Department_Subject_Id = SS.Department_Subjects_Id                
            INNER JOIN dbo.Tbl_Subject S 
                ON S.Subject_Id = DS.Subject_Id 
            INNER JOIN dbo.Tbl_Student_Semester SSe 
                ON SSe.Duration_Mapping_Id = SS.Duration_Mapping_Id 
                AND SSe.Student_Semester_Current_Status = 1               
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SSe.Candidate_Id                
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM 
                ON CDM.Duration_Mapping_Id = SSe.Duration_Mapping_Id                
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP 
                ON CDP.Duration_Period_Id = CDM.Duration_Period_Id                
            INNER JOIN dbo.Tbl_Course_Batch_Duration CBD 
                ON CBD.Batch_Id = CDP.Batch_Id                
            INNER JOIN dbo.Tbl_Course_Semester CS 
                ON CS.Semester_Id = CDP.Semester_Id                
            INNER JOIN dbo.Tbl_Department D 
                ON D.Department_Id = DS.Course_Department_Id                  
            WHERE CPD.Candidate_DelStatus = 0 
                AND CBD.Batch_Id = @Batch_Id;
        END
    ')
END
