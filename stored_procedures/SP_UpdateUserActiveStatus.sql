IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UpdateUserActiveStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
create PROCEDURE [dbo].[SP_UpdateUserActiveStatus]   
(@Candidate_id bigint=0)
AS  
BEGIN  
update [Elvis_MMU_Master_Live].[dbo].[tbl_User]
  set Active_Status=''Inactive'' where user_Id=(select User_Id from Tbl_Student_User where Candidate_Id=@Candidate_id)
END
    ')
END
