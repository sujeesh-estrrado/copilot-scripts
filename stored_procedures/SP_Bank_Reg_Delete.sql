IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_Reg_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_Reg_Delete]  
 @Bank_Id bigint  
AS  
BEGIN  
UPDATE Tbl_Bank_Registration
   SET   
 Status= 1  
 WHERE Bank_Id=@Bank_Id  
END

    ')
END;
