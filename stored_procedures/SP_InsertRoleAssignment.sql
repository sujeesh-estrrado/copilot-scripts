IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertRoleAssignment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_InsertRoleAssignment]  
  (@employee_id bigint  
           ,@role_id int  
           ,@del_Status bit,@Userid int)  
AS BEGIN  
  
  
INSERT INTO [Tbl_RoleAssignment]  
           ([employee_id]  
           ,[role_id]  
           ,[del_Status],User_ID)  
     VALUES  (@employee_id  
           ,@role_id  
           ,@del_Status,@Userid)  
   
  
END  ');
END;
