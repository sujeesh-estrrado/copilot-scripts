IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Students_By_SemesterElective]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Students_By_SemesterElective]
        (@Duration_Mapping_Id BIGINT, @Semester_Subjects_Id BIGINT)  
    AS      
    BEGIN     
        SELECT     
            SE.Candidate_Id,      
            SE.Semester_Subjects_Id,  
            C.Candidate_Fname + '' '' + ISNULL(C.Candidate_Mname, '''') + '' '' + C.Candidate_Lname AS [CandidateName]   
        FROM 
            Tbl_Semester_Elective_Students SE    
        INNER JOIN 
            Tbl_Candidate_Personal_Det C ON SE.Candidate_Id = C.Candidate_Id   
        INNER JOIN 
            Tbl_Semester_Subjects SS ON SE.Semester_Subjects_Id = SS.Semester_Subject_Id  
        WHERE 
            SE.Semester_Subjects_Id = @Semester_Subjects_Id 
            AND SS.Duration_Mapping_Id = @Duration_Mapping_Id  
        ORDER BY 
            [CandidateName]
    END
    ')
END
