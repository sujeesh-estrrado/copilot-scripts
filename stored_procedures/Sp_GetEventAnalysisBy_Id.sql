IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetEventAnalysisBy_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetEventAnalysisBy_Id]
@Event_Id bigint
as
begin
SELECT 
    (SELECT COUNT(*) FROM Tbl_EventStudentSubmit WHERE Event_Id = @Event_Id) AS SubmitedCount,
    (SELECT COUNT(*) FROM Tbl_Candidate_Personal_Det WHERE Candidate_DelStatus = 0) AS AssignToCount;

end
   ')
END;
