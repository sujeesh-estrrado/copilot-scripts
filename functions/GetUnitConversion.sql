IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetUnitConversion]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetUnitConversion] 
(
 @Product_Id bigint,    
 @Product_Units  bigint      

)
RETURNS float
AS
BEGIN

Declare @Units bigint     
Declare @ConversionFactor  float  
     
Set @Units=(Select Product_Units from Tbl_Products where Product_Id=@Product_Id)    
IF(@Units=@Product_Units)  
Begin    
Set @ConversionFactor= 1
End    
Else    
Begin    
--Set @ConversionFactor=ISNULL((Select Top 1 Unit_Conversion_factor From Tbl_Unit_Conversions where Conversion_Main_unit_Id=@Units and Conversion_Sub_units_Id=@Product_Units and Unit_Conversion_Status=0),0)  
Set @ConversionFactor=ISNULL((Select Top 1 Unit_Conversion_factor From Tbl_Unit_Conversions where Conversion_Main_unit_Id=@Product_Units  and Conversion_Sub_units_Id=@Units and Unit_Conversion_Status=0),0)  

End
RETURN @ConversionFactor 

END

    ')
END
