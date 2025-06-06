IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Candidate_Reg]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Proc_Delete_Candidate_Reg]      
(      
 @Candidate_Id Bigint ,
 @Flag bigint=0              
)      
As      
      
Begin      
  if(@Flag=0)
  begin
  if not exists(select Candidate_Id from tbl_Fee_Entry where Candidate_id=@Candidate_Id)   
      begin
          update dbo.Tbl_Candidate_Personal_Det     
          Set Candidate_DelStatus=1,Active_Status = ''INACTIVE'', [Status]= ''INACTIVE'',active=16  ,ApplicationStatus=''rejected''
          where Candidate_Id=@Candidate_Id    
      end
   else
    select 0
    end      
  
  if(@Flag=1)
  begin
  if not exists(select Candidate_Id from tbl_Fee_Entry where Candidate_id=@Candidate_Id)   
      begin
          update dbo.Tbl_Student_NewApplication     
          Set Candidate_DelStatus=1,Active_Status = ''INACTIVE'',
          -- [Status]= ''INACTIVE'',
           active=16  ,ApplicationStatus=''rejected''
          where Candidate_Id=@Candidate_Id    
      end
   else
    select 0
    end 
    if(@flag=2)
    begin
    update dbo.Tbl_candidate_personal_det     
          Set Candidate_DelStatus=1,Active_Status = ''INACTIVE'',
          Status= ''INACTIVE''
           
          where Candidate_Id=@Candidate_Id    

    end
    if(@flag=3)
    begin
    update dbo.Tbl_candidate_personal_det    
          Set Candidate_DelStatus=0,Active_Status = ''ACTIVE'',
          Status= ''ACTIVE''
           
          where Candidate_Id=@Candidate_Id    

    end
End  
  
    ')
END
