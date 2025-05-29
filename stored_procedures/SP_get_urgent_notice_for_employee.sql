IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_urgent_notice_for_candidate]')
    AND type = N'P'
)
BEGIN
    EXEC('
     
CREATE PROCEDURE [dbo].[SP_get_urgent_notice_for_candidate]  
   @CandidateId BIGINT  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Declare variables
    DECLARE @FacultyId BIGINT, @ProgramId BIGINT, @IntakeId NVARCHAR(20), @CandidateCreatedDate DATETIME;

    -- Step 1: Retrieve Faculty, Program, IntakeId, and Candidate Created Date
    SELECT 
        @FacultyId = n.Course_Level_Id,
        @ProgramId = n.Department_Id,
        @IntakeId = BD.Batch_Code,  -- Get Batch_Code from Tbl_Course_Batch_Duration
        @CandidateCreatedDate = CPD.PromoteDate  
    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = n.Batch_Id  -- Match Batch_Code with n.Batch_Id
    WHERE CPD.Candidate_Id = @CandidateId;

    -- Step 2: Get Urgent Notices for the Candidate
    SELECT  
        NB.Notice_Id,
        NB.Createdate,
        CASE 
            WHEN NB.Select_All_Students = 1 THEN 1
            WHEN EXISTS (SELECT 1 FROM Notice_Student_Maping NSM WHERE NSM.Notice_Id = NB.Notice_Id AND NSM.Student_Id = @CandidateId) THEN 1
            WHEN @FacultyId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Faculty_Maping WHERE Notice_Id = NB.Notice_Id AND Faculty_Id = @FacultyId) THEN 1
            WHEN @ProgramId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Program_Maping WHERE Notice_Id = NB.Notice_Id AND Program_Id = @ProgramId) THEN 1
            WHEN @IntakeId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Intake_Maping WHERE Notice_Id = NB.Notice_Id AND Intake_Id = @IntakeId) THEN 1
            ELSE 0
        END AS UrgentNotify,
        NB.Subject,
        NB.Annoncement,
        NB.Notice_Doc
    FROM tbl_Notice_Board NB 
    LEFT JOIN Noticeid_By_User NBU ON NB.Notice_Id = NBU.Notice_Ic AND NBU.User_Id = @CandidateId
    WHERE 
        NB.Notify_Urgently = 1  -- Only urgent notices
        AND NBU.Notice_Ic IS NULL  -- Avoid notices already seen by the candidate
        AND (
            @CandidateCreatedDate IS NULL 
            OR CONVERT(DATE, NB.Createdate) > CONVERT(DATE, @CandidateCreatedDate)
        )
        AND (
            NB.Select_All_Students = 1  
            OR EXISTS (SELECT 1 FROM Notice_Student_Maping WHERE Notice_Id = NB.Notice_Id AND Student_Id = @CandidateId)
            OR TRY_CAST(NB.selected_Students AS BIGINT) = @CandidateId  -- Direct selection for the candidate
            OR (@FacultyId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Faculty_Maping WHERE Notice_Id = NB.Notice_Id AND Faculty_Id = @FacultyId))
            OR (@ProgramId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Program_Maping WHERE Notice_Id = NB.Notice_Id AND Program_Id = @ProgramId))
            OR (@IntakeId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Intake_Maping WHERE Notice_Id = NB.Notice_Id AND Intake_Id = @IntakeId))
        )
    ORDER BY NB.Notice_Id ASC;  

    SET NOCOUNT OFF;  
END;

    ')
END
GO