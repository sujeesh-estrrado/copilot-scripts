IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Sms_Template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Update_Sms_Template]        
(@Template_id bigint,       
@Template_Content varchar(MAX),
@Template_Description varchar(MAX))         
        
As     
  
 
Begin   
        
Update Tbl_Sms_Template  set Template_Content=@Template_Content,Template_Description=@Template_Description    Where Template_id=@Template_id    
    
    
    
    
End

    ')
END
