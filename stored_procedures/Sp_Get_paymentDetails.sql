IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Products_All_With_Search_Count]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_Products_All_With_Search_Count]            
(                  
@SearchTerm varchar(100)          
)            
                
AS            
            
BEGIN  
SELECT  ROW_NUMBER() over (ORDER BY dbo.Tbl_Products.Product_Id DESC) AS RowNumber,  
  
    dbo.Tbl_Products.Product_Id as ID,   
   
    dbo.Tbl_Products.Product_Name as Product,  
  
    Tbl_Product_Categories.Prod_Cat_Name as Category,   
  
    dbo.Tbl_Products.Product_Code as Code          
     
FROM         dbo.Tbl_Products   
  
    left JOIN dbo.Tbl_Product_Categories ON dbo.Tbl_Products.Prod_Cat_Id = dbo.Tbl_Product_Categories.Prod_Cat_Id         
                          
WHERE     (dbo.Tbl_Products.Product_Del_Status = 0)       
      
      
and  (dbo.Tbl_Products.Product_Name like  ''''+ @SearchTerm+''%''       
      
or Tbl_Product_Categories.Prod_Cat_Name like  ''''+ @SearchTerm+''%''   
  
or  dbo.Tbl_Products.Product_Code like  ''''+ @SearchTerm+''%''      
      
)  
  
end
    ')
END
GO