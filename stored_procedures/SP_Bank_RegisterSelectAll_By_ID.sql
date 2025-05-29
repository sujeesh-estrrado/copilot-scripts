IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_RegisterSelectAll_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_RegisterSelectAll_By_ID]     
 @Bank_Id bigint    
AS    
BEGIN    
SELECT *  
  FROM Tbl_Bank_Registration
WHERE Bank_Id=@Bank_Id    
END

    ')
END;
