IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Student_Batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Student_Batch]    
        (    
            @CandidateId BIGINT    
        )    
        AS    
        BEGIN    
            SELECT 
                SS.*,    
                CONCAT(CPD.Candidate_Fname, '' '', 
                       ISNULL(CPD.Candidate_Mname, ''''), '' '', 
                       CPD.Candidate_Lname) AS [Student Name],        
                CONCAT(CPD.Candidate_Fname, '' '', 
                       ISNULL(CPD.Candidate_Mname, ''''), '' '', 
                       CPD.Candidate_Lname) AS StudentName,        
                CONCAT(Batch_Code, ''-'', Semester_Code) AS BatchSemester
            FROM dbo.Tbl_Student_Semester SS   
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SS.Candidate_Id  
            INNER JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id       
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDM.Duration_Period_Id = CDP.Duration_Period_Id          
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id           
            INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id         
            WHERE 
                SS.Candidate_Id = @CandidateId 
                AND SS.Student_Semester_Delete_Status = 0 
                AND SS.Student_Semester_Current_Status = 1  
                AND CPD.Candidate_DelStatus = 0    
        END
    ')
END
