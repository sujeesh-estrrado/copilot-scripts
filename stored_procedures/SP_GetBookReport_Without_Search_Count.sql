IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBookReport_Without_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GetBookReport_Without_Search_Count]                                  
AS                                  
BEGIN     
                                 
SELECT ROW_NUMBER() over (ORDER BY Tbl_AddBooks.Book_Id DESC) AS RowNumber,
 Tbl_AddBooks.Book_Id as ID,

 Tbl_AddBooks.Book_Title as [Title],                                   
                               
 Tbl_AddBooks.Book_Serial_No as [Serial No],     
    
 Tbl_AddBooks.Book_Code as [Code],  

 Tbl_AddBooks.Book_Author as [Author],  
    
 Tbl_BookCategory.Category_Name as [Category],  
  
 Tbl_Book_SubCategory.SubCategory_Name as [Sub-Category],  
  
       
      
case when  Tbl_AddBooks.Publisher_Id=0 then ''Not Provided'' else (      
select Publisher_Name from Tbl_Book_Publisher where Publisher_Id=Tbl_AddBooks.Publisher_Id) end as Publisher,      
       
case when  Tbl_AddBooks.Almeria_Rack_Id=0 then ''Not Provided'' else (      
select Almeria_Rack_Name from Tbl_Book_Almeria_Rack where Almeria_Rack_Id=Tbl_AddBooks.Almeria_Rack_Id       
) end as Rack                                            
                   
FROM Tbl_AddBooks                      
INNER Join Tbl_BookCategory ON Tbl_AddBooks.Category_Id=Tbl_BookCategory.Category_Id                      
INNER JOIN Tbl_Book_SubCategory ON Tbl_AddBooks.SubCategory_Id=Tbl_Book_SubCategory.SubCategory_Id                      
                      
                      
 WHERE  Tbl_AddBooks.Book_Del_Status=0         
        
        
    
        
end');
END;
