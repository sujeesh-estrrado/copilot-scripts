IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_notices_for_candidate]')
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE PROCEDURE [dbo].[SP_get_notices_for_candidate]  
   @CandidateId BIGINT  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Declare variables
    DECLARE @FacultyId BIGINT, @ProgramId BIGINT, @IntakeId NVARCHAR(20);  -- Changed to NVARCHAR for Batch_Code
    DECLARE @CandidateAdmissionDate DATETIME;

    -- Step 1: Get Faculty ID, Program ID, Intake ID (Batch_Code), and Admission Date for the Candidate (Only for New Admissions)
    SELECT 
        @FacultyId = n.Course_Level_Id,
        @ProgramId = n.Department_Id,
        @IntakeId = BD.Batch_Code,  -- Get the Batch_Code as @IntakeId
        @CandidateAdmissionDate = CPD.RegDate -- Assuming Admission_Date is in the Tbl_Candidate_Personal_Det table
    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = n.Batch_Id  -- Match Batch_Code with n.Batch_Id
    WHERE CPD.Candidate_Id = @CandidateId;

    -- Debugging: Check if the variables are being populated correctly
    PRINT ''FacultyId: '' + CAST(@FacultyId AS NVARCHAR(20));
    PRINT ''ProgramId: '' + CAST(@ProgramId AS NVARCHAR(20));
    PRINT ''IntakeId: '' + @IntakeId;
    PRINT ''CandidateAdmissionDate: '' + CAST(@CandidateAdmissionDate AS NVARCHAR(20));

    -- Step 2: Get the last 3 Notice_Ids for this Candidate, after the candidate''s admission date
    IF @FacultyId IS NOT NULL AND @ProgramId IS NOT NULL AND @IntakeId IS NOT NULL
    BEGIN
        SELECT TOP 3 
            NB.Notice_Id,
            NB.Createdate,
            CASE 
                WHEN NB.Select_All_Students = 1 THEN 1
                WHEN EXISTS (SELECT 1 FROM Notice_Student_Maping NSM WHERE NSM.Notice_Id = NB.Notice_Id AND NSM.Student_Id = @CandidateId) THEN 1
                WHEN EXISTS (SELECT 1 FROM Notice_Faculty_Maping WHERE Notice_Id = NB.Notice_Id AND Faculty_Id = @FacultyId) THEN 1
                WHEN EXISTS (SELECT 1 FROM Notice_Program_Maping WHERE Notice_Id = NB.Notice_Id AND Program_Id = @ProgramId) THEN 1
                WHEN EXISTS (SELECT 1 FROM Notice_Intake_Maping WHERE Notice_Id = NB.Notice_Id AND Intake_Id = @IntakeId) THEN 1
                ELSE 0
            END AS UrgentNotify,
            NB.Subject,
            NB.Annoncement,
            NB.Notice_Doc
        FROM tbl_Notice_Board NB
        WHERE 
            (NB.Select_All_Students = 1  
            OR EXISTS (SELECT 1 FROM Notice_Student_Maping WHERE Notice_Id = NB.Notice_Id AND Student_Id = @CandidateId)
            OR TRY_CAST(NB.selected_Students AS BIGINT) = @CandidateId  
            OR EXISTS (SELECT 1 FROM Notice_Faculty_Maping WHERE Notice_Id = NB.Notice_Id AND Faculty_Id = @FacultyId))
            OR EXISTS (SELECT 1 FROM Notice_Program_Maping WHERE Notice_Id = NB.Notice_Id AND Program_Id = @ProgramId)
            OR EXISTS (SELECT 1 FROM Notice_Intake_Maping WHERE Notice_Id = NB.Notice_Id AND Intake_Id = @IntakeId) -- Use IntakeId for batch filtering
            AND NB.Createdate > @CandidateAdmissionDate -- Only select notices after the candidate''s admission date
        ORDER BY NB.Notice_Id DESC;  
    END

    SET NOCOUNT OFF;  
END;  
    ')
END
GO
