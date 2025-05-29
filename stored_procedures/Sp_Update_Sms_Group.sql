IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Sms_Group]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Update_Sms_Group]        
(@Group_id bigint,       
@Group_Name varchar(150))         
        
As     
  
 
Begin   
        
Update Tbl_Sms_Group  set Group_Name=@Group_Name    Where Group_id=@Group_id    
    
    
    
    
End

   ')
END;
