IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CandidateUser_ByUserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_CandidateUser_ByUserId](@User_Id int)  
  
AS  
Set NoCount ON  
BEGIN  
  
SELECT U.[user_Id],U.role_Id,U.user_Status
FROM  Tbl_User U inner join tbl_Role r on r.role_Id=u.role_Id
WHERE U.[user_Id]=@User_Id  and r.role_Name=''Candidate'' or r.role_Name=''Parent''
     
END
    ')
END
