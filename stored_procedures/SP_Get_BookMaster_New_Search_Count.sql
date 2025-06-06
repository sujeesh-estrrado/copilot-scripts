IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_BookMaster_New_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_BookMaster_New_Search_Count]        
(        
@SearchTerm  varchar(100)        
)        
        
as        
        
begin        
        
SELECT ROW_NUMBER() OVER (ORDER BY Book_Master_Id DESC) AS RowNumber,Base.*  FROM
    (SELECT DISTINCT  
MB.Book_Master_Id,
Book_Master_Name as [Title],
MB.Number_of_Copy as [Number of Copies], 
BC.Category_Name as [Category],  
BS.SubCategory_Name as [Sub-Category],  
AB.Price 

 FROM dbo.Tbl_AddBook_Master MB   
inner join dbo.Tbl_AddBooks AB on AB.Book_Master_Id=MB.Book_Master_Id  
inner join dbo.Tbl_BookCategory BC on BC.Category_Id=AB.Category_Id  
inner join dbo.Tbl_Book_SubCategory BS on BS.SubCategory_Id=AB.SubCategory_Id  ) Base     
    
WHERE
([Title] like  ''''+ @SearchTerm+''%''   
  
or  [Number of Copies] like  ''''+ @SearchTerm+''%''     

or  [Category] like  ''''+ @SearchTerm+''%''   
  
or  [Sub-Category] like  ''''+ @SearchTerm+''%''   
  
or  Base.Price like  ''''+ @SearchTerm+''%''  
    
)        
        
end
    ');
END
