IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Account_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_Account_Delete]  
 @Account_Id bigint  
AS  
BEGIN  
UPDATE Tbl_Bank_Account_Mapping
   SET   
 Status= 1  
 WHERE Account_Id=@Account_Id  
END
    ')
END;
