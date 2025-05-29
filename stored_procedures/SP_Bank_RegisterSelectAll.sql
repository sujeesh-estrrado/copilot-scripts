IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Bank_RegisterSelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Bank_RegisterSelectAll]        
AS        
BEGIN        
SELECT * 
FROM  Tbl_Bank_Registration     
WHERE Status=0        
END
    ')
END;
