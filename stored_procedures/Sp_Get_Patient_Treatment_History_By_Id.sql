IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Products_All]')
    AND type = N'P'
)
BEGIN
    EXEC('
         
CREATE procedure [dbo].[SP_Get_Products_All]            
(            
                
@CurrentPage int = null,            
@PageSize int = null  ,        
@SearchTerm varchar(100)          
)            
                
AS            
            
BEGIN            
    SET NOCOUNT ON            
            
    DECLARE @SqlString nvarchar(max)        
 Declare @SqlStringWithout nvarchar(max)            
    Declare @UpperBand int            
    Declare @LowerBand int                    
                
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                
            
    BEGIN            
             
      
      
IF @SearchTerm IS NOT NULL      
      
BEGIN      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT       
    dbo.Tbl_Products.Product_Id as ID,   
    dbo.Tbl_Products.Prod_Cat_Id,   
    dbo.Tbl_Products.Product_Name,   
    dbo.Tbl_Products.Product_Code,   
    dbo.Tbl_Products.Product_Type,         
                dbo.Tbl_Products.Product_Img_name,   
    dbo.Tbl_Products.Product_Barcode_Status,   
    dbo.Tbl_Products.Product_barcode_Id,   
    dbo.Tbl_Products.Product_Units,         
                dbo.Tbl_Products.Product_Min_Quantity,   
    dbo.Tbl_Products.Prod_ManufacturerId,   
    dbo.Tbl_Products.Prod_Distributor_Id,   
    dbo.Tbl_Products.Prod_Description,         
                dbo.Tbl_Products.Prod_SkuCode,   
    dbo.Tbl_Products.Prod_UpcCode,         
    Tbl_Product_Categories.Prod_Cat_Name  
  
,ROW_NUMBER() over (ORDER BY dbo.Tbl_Products.Product_Id DESC) AS RowNumber   
     
FROM         dbo.Tbl_Products   
    left JOIN dbo.Tbl_Product_Categories ON dbo.Tbl_Products.Prod_Cat_Id = dbo.Tbl_Product_Categories.Prod_Cat_Id         
                          
WHERE     (dbo.Tbl_Products.Product_Del_Status = 0)       
      
      
and  (dbo.Tbl_Products.Product_Name like  ''''''+ @SearchTerm+''%''''       
      
or Tbl_Product_Categories.Prod_Cat_Name like  ''''''+ @SearchTerm+''%''''   
  
or  dbo.Tbl_Products.Product_Code like  ''''''+ @SearchTerm+''%''''      
      
)      
               
        )                 
            
        SELECT             
    ID,   
    Prod_Cat_Id,   
    Product_Name,   
    Product_Code,   
    Product_Type,         
                Product_Img_name,   
    Product_Barcode_Status,   
    Product_barcode_Id,   
    Product_Units,         
                Product_Min_Quantity,   
    Prod_ManufacturerId,   
    Prod_Distributor_Id,   
    Prod_Description,         
                Prod_SkuCode,   
    Prod_UpcCode,         
    Prod_Cat_Name,  
    RowNumber                                  
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT       
    dbo.Tbl_Products.Product_Id as ID,   
    dbo.Tbl_Products.Prod_Cat_Id,   
    dbo.Tbl_Products.Product_Name,   
    dbo.Tbl_Products.Product_Code,   
    dbo.Tbl_Products.Product_Type,         
                dbo.Tbl_Products.Product_Img_name,   
    dbo.Tbl_Products.Product_Barcode_Status,   
    dbo.Tbl_Products.Product_barcode_Id,   
    dbo.Tbl_Products.Product_Units,         
                dbo.Tbl_Products.Product_Min_Quantity,   
    dbo.Tbl_Products.Prod_ManufacturerId,   
    dbo.Tbl_Products.Prod_Distributor_Id,   
    dbo.Tbl_Products.Prod_Description,         
                dbo.Tbl_Products.Prod_SkuCode,   
    dbo.Tbl_Products.Prod_UpcCode,         
    Tbl_Product_Categories.Prod_Cat_Name  
  
,ROW_NUMBER() over (ORDER BY dbo.Tbl_Products.Product_Id DESC) AS RowNumber   
     
FROM         dbo.Tbl_Products   
    left JOIN dbo.Tbl_Product_Categories ON dbo.Tbl_Products.Prod_Cat_Id = dbo.Tbl_Product_Categories.Prod_Cat_Id         
                          
WHERE     (dbo.Tbl_Products.Product_Del_Status = 0)                
        )                 
            
        SELECT             
    ID,   
    Prod_Cat_Id,   
    Product_Name,   
    Product_Code,   
    Product_Type,         
                Product_Img_name,   
    Product_Barcode_Status,   
    Product_barcode_Id,   
    Product_Units,         
                Product_Min_Quantity,   
    Prod_ManufacturerId,   
    Prod_Distributor_Id,   
    Prod_Description,         
                Prod_SkuCode,   
    Prod_UpcCode,         
    Prod_Cat_Name,  
    RowNumber                                  
        FROM             
            tempProfile  WHERE RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END
    ')
END
GO