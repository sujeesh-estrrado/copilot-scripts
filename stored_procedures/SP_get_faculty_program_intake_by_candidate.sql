IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_faculty_program_intake_by_candidate]')
    AND type = N'P'
)
BEGIN
    EXEC('

create PROCEDURE [dbo].[SP_get_faculty_program_intake_by_candidate]  
   @CandidateId BIGINT  
AS  
BEGIN  
    SET NOCOUNT ON;  

    SELECT 
        n.Course_Level_Id AS FacultyId,
        n.Department_Id AS ProgramId,
        n.Batch_Id AS IntakeId
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN 
        tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE 
        CPD.Candidate_Id = @CandidateId;
    
    SET NOCOUNT OFF;  
END;

    ')
END
