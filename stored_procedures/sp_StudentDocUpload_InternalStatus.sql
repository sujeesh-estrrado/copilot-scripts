IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentDocUpload_InternalStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[sp_StudentDocUpload_InternalStatus]
(
@Candidate_Id bigint
)
as 
begin
    select StudentId as candidate_id,IsInternal from tbl_StudentDocUpload where StudentId=@Candidate_Id

end
    ')
END
