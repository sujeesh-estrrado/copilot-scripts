IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Currency]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Currency]    
    
AS    
    
BEGIN    
    
 SELECT Currency_Id ,CurrencyName,CurrencyCode    
  FROM Tbl_Currency 
order by CurrencyName   
       
END


   ')
END;
