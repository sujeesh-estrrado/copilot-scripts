IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Bank_Transfer_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Bank_Transfer_Delete]        
 @Bank_Id bigint        
AS        
BEGIN        
UPDATE Tbl_Bank_Transfer       
   SET         
 Bank_Status= 1        
 WHERE Bank_Id=@Bank_Id        
END
    ')
END;
