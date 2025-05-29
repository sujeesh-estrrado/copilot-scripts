IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_CourseInfo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_CourseInfo]
(@candidate_id BIGINT,@Candidate_NewAdmissionId BIGINT,@Candidate_InitialAppId BIGINT)

AS BEGIN
UPDATE dbo.Tbl_Candidate_Personal_Det SET New_Admission_Id=@Candidate_NewAdmissionId,
Initial_Application_Id=@Candidate_InitialAppId WHERE Candidate_Id=@candidate_id

SELECT @candidate_id

END
    ')
END;
