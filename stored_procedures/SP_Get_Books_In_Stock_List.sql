IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Books_In_Stock_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[SP_Get_Books_In_Stock_List]                 
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
        (Select              
B.Book_Id as ID ,           
B.Book_Serial_No,            
B.Book_Suffix as [Suffix],              
B.Book_Prefix as [Prefix],                
B.Book_Title as [Title],              
B.Book_Author as [Author],              
B.Book_Code,                
B.Category_Id,              
B.Book_Master_Id,            
BC.Category_Name as [Category Name],                
B.SubCategory_Id,                
BSC.SubCategory_Name as [SubCategory],              
B.Publisher_Id,                       
B.Almeria_Rack_Id ,                
      
case when  B.Publisher_Id=0 then ''''Not Provided''''     
 else (select Publisher_Name from Tbl_Book_Publisher where Publisher_Id=B.Publisher_Id) end as Publisher,       
case when  B.Almeria_Rack_Id=0 then ''''Not Provided''''     
 else (select Almeria_Rack_Name from Tbl_Book_Almeria_Rack where Almeria_Rack_Id=B.Almeria_Rack_Id) end as Rack        
      
,ROW_NUMBER() over (ORDER BY B.Book_Id DESC) AS RowNumber     
          
From Tbl_AddBooks B              
INNER Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id                
INNER JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id                
           
WHERE Book_Id not in ((Select Book_Id From Tbl_LMS_Issue_Book Where Issue_Book_Status=0 and Is_Returned=0)              
union (Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0 and Is_LostReturn=0)              
union (Select Book_Id From Tbl_LMS_Book_Weeding Where Book_Weeding_Status=0 and Is_Returned=0))                
and               
Book_Del_Status=0          
          
          
and  (B.Book_Title like  ''''''+ @SearchTerm+''%''''         
        
or B.Book_Serial_No like  ''''''+ @SearchTerm+''%''''    
    
or  B.Book_Code like  ''''''+ @SearchTerm+''%''''      
        
or  BC.Category_Name like  ''''''+ @SearchTerm+''%''''         
        
or  BSC.SubCategory_Name like  ''''''+ @SearchTerm+''%''''         
        
or  B.Book_Author like  ''''''+ @SearchTerm+''%''''    
    
or  B.Publisher_Id like  ''''''+ @SearchTerm+''%''''         
          
)          
          
               
        )                     
                
        SELECT                 
   ID,    
   Book_Serial_No,              
            [Suffix],              
            [Prefix],              
            [Title],              
            [Author],               
            Book_Code,        
   Category_Id,    
   Book_Master_Id,      
   [Category Name],      
   SubCategory_Id,      
   [SubCategory],       
   Publisher_Id,    
   Almeria_Rack_Id,      
   Publisher,      
   Rack,       
   RowNumber                                    
        FROM                 
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)          
          
          
END          
          
--IF @SearchTerm is null            
          
 IF (@SearchTerm is null or @SearchTerm = '''')          
          begin          
          
 SET @SqlString=''WITH tempProfile AS                
        (Select              
B.Book_Id as ID ,           
B.Book_Serial_No,            
B.Book_Suffix as [Suffix],              
B.Book_Prefix as [Prefix],       
B.Book_Title as [Title],              
B.Book_Author as [Author],              
B.Book_Code,                
B.Category_Id,              
B.Book_Master_Id,            
BC.Category_Name as [Category Name],                
B.SubCategory_Id,                
BSC.SubCategory_Name as [SubCategory],              
B.Publisher_Id,                        
B.Almeria_Rack_Id ,                
      
case when  B.Publisher_Id=0 then ''''Not Provided''''     
 else (select Publisher_Name from Tbl_Book_Publisher where Publisher_Id=B.Publisher_Id) end as Publisher,       
case when  B.Almeria_Rack_Id=0 then ''''Not Provided''''     
 else (select Almeria_Rack_Name from Tbl_Book_Almeria_Rack where Almeria_Rack_Id=B.Almeria_Rack_Id) end as Rack        
      
,ROW_NUMBER() over (ORDER BY B.Book_Id DESC) AS RowNumber     
          
From Tbl_AddBooks B              
INNER Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id                
INNER JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id                
           
WHERE Book_Id not in ((Select Book_Id From Tbl_LMS_Issue_Book Where Issue_Book_Status=0 and Is_Returned=0)              
union (Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0 and Is_LostReturn=0)              
union (Select Book_Id From Tbl_LMS_Book_Weeding Where Book_Weeding_Status=0 and Is_Returned=0))                
and               
Book_Del_Status=0          
               
)                     
                
        SELECT                 
   ID,    
   Book_Serial_No,              
            [Suffix],              
            [Prefix],              
            [Title],              
            [Author],               
            Book_Code,        
   Category_Id,    
   Book_Master_Id,      
   [Category Name],      
   SubCategory_Id,      
   [SubCategory],       
   Publisher_Id,    
   Almeria_Rack_Id,      
   Publisher,      
   Rack,       
   RowNumber                                  
        FROM                 
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)          
          
          
end          
          
   EXEC sp_executesql @SqlString                
            
                
    END                
END
    ')
END
