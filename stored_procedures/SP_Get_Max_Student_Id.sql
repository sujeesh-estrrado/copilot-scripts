IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Max_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Get_Max_Student_Id]  
  
  
as  
  
begin  
  
select isnull(max(Candidate_Id)+1,0) as  Max_Candidate_Id from Tbl_Candidate_Personal_Det
  
end


    ')
END;
