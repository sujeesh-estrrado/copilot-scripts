IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetBookList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    

CREATE procedure [dbo].[SP_GetBookList]             
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
        (                                
             SELECT Tbl_AddBooks.Book_Id as ID ,    
Tbl_AddBooks.Book_Suffix as [Suffix],    
Tbl_AddBooks.Book_Prefix as [Prefix],                          
Tbl_AddBooks.Book_Title as [Title],    
Tbl_AddBooks.Book_Author as [Author],    
Tbl_AddBooks.Book_Code,    
Tbl_AddBooks.Book_Serial_No ,                         
Tbl_AddBooks.Category_Id,    
Tbl_BookCategory.Category_Name as [Category Name],                          
Tbl_AddBooks.SubCategory_Id,     
Tbl_Book_SubCategory.SubCategory_Name as [SubCategory],                       
Tbl_AddBooks.Book_Master_Id,                      
                     
Tbl_AddBooks.Publisher_Id,          
          
case when  Tbl_AddBooks.Publisher_Id=0 then ''''Not Provided'''' else (          
select Publisher_Name from Tbl_Book_Publisher where Publisher_Id=Tbl_AddBooks.Publisher_Id) end as Publisher,          
           
case when  Tbl_AddBooks.Almeria_Rack_Id=0 then ''''Not Provided'''' else (          
select Almeria_Rack_Name from Tbl_Book_Almeria_Rack where Almeria_Rack_Id=Tbl_AddBooks.Almeria_Rack_Id           
) end as Rack,    
Tbl_AddBooks.Almeria_Rack_Id                           
          
 ,ROW_NUMBER() over (ORDER BY Tbl_AddBooks.Book_Id DESC) AS RowNumber           
                       
FROM Tbl_AddBooks                          
INNER Join Tbl_BookCategory ON Tbl_AddBooks.Category_Id=Tbl_BookCategory.Category_Id                          
INNER JOIN Tbl_Book_SubCategory ON Tbl_AddBooks.SubCategory_Id=Tbl_Book_SubCategory.SubCategory_Id                          
                          
                          
 WHERE  Tbl_AddBooks.Book_Del_Status=0      
      
      
and  (Tbl_AddBooks.Book_Title like  ''''''+ @SearchTerm+''%''''     
    
or Tbl_AddBooks.Book_Serial_No like  ''''''+ @SearchTerm+''%''''       
      
or Tbl_AddBooks.Book_Code like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_BookCategory.Category_Name like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_Book_SubCategory.SubCategory_Name like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_AddBooks.Book_Author like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_AddBooks.Publisher_Id like  ''''''+ @SearchTerm+''%''''    
      
)      
      
           
        )                 
            
        SELECT             
            ID,            
            [Suffix],            
            [Prefix],            
            [Title],            
            [Author],             
            Book_Code,    
      Book_Serial_No,    
   Category_Id,    
   [Category Name],    
   SubCategory_Id,    
   [SubCategory],    
   Book_Master_Id,    
   Publisher_Id,    
   Publisher,    
   Rack,    
   Almeria_Rack_Id,    
   RowNumber                                
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (                                
             SELECT Tbl_AddBooks.Book_Id as ID ,    
Tbl_AddBooks.Book_Suffix as [Suffix],    
Tbl_AddBooks.Book_Prefix as [Prefix],                          
Tbl_AddBooks.Book_Title as [Title],    
Tbl_AddBooks.Book_Author as [Author],    
Tbl_AddBooks.Book_Code,    
Tbl_AddBooks.Book_Serial_No ,                         
Tbl_AddBooks.Category_Id,    
Tbl_BookCategory.Category_Name as [Category Name],                          
Tbl_AddBooks.SubCategory_Id,     
Tbl_Book_SubCategory.SubCategory_Name as [SubCategory],                       
Tbl_AddBooks.Book_Master_Id,                      
                     
Tbl_AddBooks.Publisher_Id,          
          
case when  Tbl_AddBooks.Publisher_Id=0 then ''''Not Provided'''' else (          
select Publisher_Name from Tbl_Book_Publisher where Publisher_Id=Tbl_AddBooks.Publisher_Id) end as Publisher,          
           
case when  Tbl_AddBooks.Almeria_Rack_Id=0 then ''''Not Provided'''' else (          
select Almeria_Rack_Name from Tbl_Book_Almeria_Rack where Almeria_Rack_Id=Tbl_AddBooks.Almeria_Rack_Id           
) end as Rack,    
Tbl_AddBooks.Almeria_Rack_Id                           
          
 ,ROW_NUMBER() over (ORDER BY Tbl_AddBooks.Book_Id DESC) AS RowNumber           
                       
FROM Tbl_AddBooks                          
INNER Join Tbl_BookCategory ON Tbl_AddBooks.Category_Id=Tbl_BookCategory.Category_Id                          
INNER JOIN Tbl_Book_SubCategory ON Tbl_AddBooks.SubCategory_Id=Tbl_Book_SubCategory.SubCategory_Id                          
                          
                          
 WHERE  Tbl_AddBooks.Book_Del_Status=0      
      
      
and  (Tbl_AddBooks.Book_Title like  ''''''+ @SearchTerm+''%''''     
    
or Tbl_AddBooks.Book_Serial_No like  ''''''+ @SearchTerm+''%''''       
      
or Tbl_AddBooks.Book_Code like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_BookCategory.Category_Name like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_Book_SubCategory.SubCategory_Name like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_AddBooks.Book_Author like  ''''''+ @SearchTerm+''%''''     
    
or  Tbl_AddBooks.Publisher_Id like  ''''''+ @SearchTerm+''%''''    
      
)      
      
           
        )                 
            
        SELECT             
            ID,            
            [Suffix],            
            [Prefix],            
            [Title],            
            [Author],             
            Book_Code,    
      Book_Serial_No,    
   Category_Id,    
   [Category Name],    
   SubCategory_Id,    
   [SubCategory],    
   Book_Master_Id,    
   Publisher_Id,    
   Publisher,    
   Rack,    
   Almeria_Rack_Id,    
   RowNumber                                
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END
');
END;
