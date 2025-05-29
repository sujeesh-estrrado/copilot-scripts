IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Subject_By_CandidId]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[SP_Get_Subject_By_CandidId] --241,51

(@CandidateId bigint,@Duration_mapping_id bigint)

AS BEGIN

SELECT C.Subject_Id FROM dbo.Tbl_Student_Subject_Child C 
INNER JOIN 
dbo.Tbl_Student_Subject_Master M ON 
M.Student_Subject_Map_Master=C.Student_Subject_Map_Master
WHERE M.Candidate_Id=@CandidateId and Duration_mapping_id=@Duration_mapping_id

END

    ')
END;
