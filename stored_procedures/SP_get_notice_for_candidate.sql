IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_notice_for_candidate]')
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE PROCEDURE [dbo].[SP_get_notice_for_candidate]
   @CandidateId BIGINT  
AS  
BEGIN  
    SET NOCOUNT ON;

    -- Step 1: Get Faculty ID of the Candidate
    DECLARE @FacultyId BIGINT;
    SELECT @FacultyId = n.Course_Level_Id
    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE CPD.Candidate_Id = @CandidateId;

    -- Step 2: Fetch Notices with Urgent Notify = 1
    SELECT DISTINCT n.Notice_Id
    FROM tbl_Notice_Board n
    INNER JOIN Notice_Faculty_Maping m ON n.Notice_Id = m.Notice_Id
    WHERE n.Notify_Urgently = 1
    AND m.Faculty_Id = @FacultyId;  -- Check if Candidate''s Faculty exists in mapping

    SET NOCOUNT OFF;
END;
    ')
END
GO
