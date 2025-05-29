IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[CalculateTaxAmount]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
 
CREATE FUNCTION [dbo].[CalculateTaxAmount] 
(
    @TaxGroup_Id bigint
)
RETURNS decimal(18,2)
AS
BEGIN

    DECLARE @Tax decimal(18,2);
    
    SELECT @Tax = 
(Select Sum(TaxClass_Value) From  Tbl_TaxClass tc Inner Join Tbl_TaxGroupMapping tgm 
On tc.TaxClass_Id=tgm.TaxClass_Id
where tgm.TaxGroup_Id=@TaxGroup_Id)


    RETURN @Tax

END
    ')
END
