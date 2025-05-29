IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Candidate_EducationDetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Delete_Candidate_EducationDetails]
(@Candidate_Id bigint)
AS
BEGIN

DELETE FROM [Tbl_Candidate_EducationDetails]
      WHERE Candidate_Id=@Candidate_Id
END

    ')
END