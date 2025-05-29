IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SmsGroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_SmsGroup]      
      
AS      
      
BEGIN      
      
SELECT  Group_id,Group_Name  
  FROM [dbo].[Tbl_Sms_Group] order by Group_Name desc  
         
END



   ')
END;
