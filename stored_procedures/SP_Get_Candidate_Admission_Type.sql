IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_Admission_Type]')
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE procedure [dbo].[SP_Get_Candidate_Admission_Type](@Candidate_Id bigint)      
as      
begin      
select AdmissionType    
from Tbl_Candidate_Personal_Det where  Candidate_Id=@Candidate_Id and Candidate_DelStatus=0      
      
end
    ')
END