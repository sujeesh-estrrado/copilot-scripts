IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Students_byDurationMapping_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Students_byDurationMapping_Id] 
        @Duration_Mapping_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            SELECT  
                cpd.Candidate_Id,  
                cpd.Candidate_Fname + '' '' + 
                ISNULL(cpd.Candidate_Mname, '''') + '' '' + 
                cpd.Candidate_Lname AS CandidateName  
            FROM Tbl_Candidate_Personal_Det cpd    
            INNER JOIN Tbl_Student_Semester S 
                ON cpd.Candidate_Id = S.Candidate_Id  
            WHERE S.Student_Semester_Current_Status = 1 
                AND S.Duration_Mapping_Id = @Duration_Mapping_Id 
                AND cpd.Candidate_DelStatus = 0;
        END
    ')
END
