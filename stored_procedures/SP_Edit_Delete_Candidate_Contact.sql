IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Edit_Delete_Candidate_Contact]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Edit_Delete_Candidate_Contact]     
(      
 @Cand_Contact_Mapping_Id Bigint,      
  @flag bigint        
)      
As      
      
Begin      
if(@flag=1)
begin
  update dbo.Tbl_Candidate_ContactDetails_Mapping     
  Set Delete_Status=1
  where Cand_Contact_Mapping_Id=@Cand_Contact_Mapping_Id    
      end

      if(@flag=2)
begin
  update dbo.Tbl_Candidate_ContactDetails_Mapping     
  Set Delete_Status=0
  where Cand_Contact_Mapping_Id=@Cand_Contact_Mapping_Id    
      end
End 

    ')
END;
