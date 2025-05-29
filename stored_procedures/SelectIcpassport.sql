IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectIcpassport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SelectIcpassport]    
as    
begin    
   select 
        Candidate_Id,
        AdharNumber 
   from dbo.Tbl_Candidate_Personal_Det  
   where Candidate_DelStatus=0 
   and AdharNumber!='' ''  
   order by AdharNumber desc  
end

    ')
END;
