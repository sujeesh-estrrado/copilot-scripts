IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Set_PreactivateFlag]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Set_PreactivateFlag]          
(@CandidateId bigint)                                      
as                                      
begin      
     
   update Tbl_Candidate_Personal_Det set PreactivateFlag=''1'' where Candidate_Id=@CandidateId  
end  
    ')
END;
