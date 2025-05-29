IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceCodeById_Code]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetInvoiceCodeById_Code] 
(
  @Invoice_Code_Id bigint,
  @Invoice_code varchar(100)
)
RETURNS varchar(100)
AS
BEGIN

    DECLARE @code varchar(100);
    
    SELECT @code = (SELECT Invoice_Code_Prefix+@Invoice_code+Invoice_Code_Suffix 
     From Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id)


    RETURN @code

END
    ')
END
