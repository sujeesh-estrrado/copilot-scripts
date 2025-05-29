IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SmsTemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_SmsTemplate]        
        
AS        
        
BEGIN        
        
SELECT  *    
  FROM [dbo].[Tbl_Sms_Template] order by Template_Content desc    
           
END
    
    ')
END
