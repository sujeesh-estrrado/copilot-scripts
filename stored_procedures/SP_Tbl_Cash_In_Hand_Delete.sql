IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Cash_In_Hand_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Cash_In_Hand_Delete]      
 @Cash_Id bigint      
AS      
BEGIN      
UPDATE Tbl_Cash_In_Hand     
   SET       
 Cash_Status= 1      
 WHERE Cash_Id=@Cash_Id      
END
    ')
END;
