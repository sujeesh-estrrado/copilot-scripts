IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Lost_Book]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_All_Lost_Book]      
(                
                    
@CurrentPage int = null,                
@PageSize int = null,    
@SearchTerm varchar(100),    
@SearchTerm1 varchar(100)                      
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
    
IF ((@SearchTerm IS NOT NULL)  or (@SearchTerm1 IS NOT NULL))        
          
BEGIN              
       
          
 SET @SqlString=''WITH tempProfile AS                
        (SELECT                           
 [Lost_Stolen_Id],                        
    A.Book_Id as ID,        
    A.Book_Code,        
    BC.Category_Id as [CategoryId],        
    BC.Category_Name as [Category Name],        
    BS.SubCategory_Id as [SubCategoryId],         
    BS.SubCategory_Name as SubCategory,              
    [Issue_Book_Id],              
    A.Book_Serial_No,                 
    [Is_LostReturn],                  
    L.[Remarks],                  
    [New_or_Fine_Status],                  
    [Amount],                  
    [Lost_Stolen_Status],                 
    [Book_Title] as Title,                  
    BP.Publisher_Name as [Publisher],        
    A.Book_Author as Author,     
       
Case when A.Book_Id in ((Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0)) and Book_Del_Status=0                  
then ''''Lost''''                  
end as Status,    
    
ROW_NUMBER() over (ORDER BY A.Book_Id DESC) AS RowNumber          
               
  FROM [dbo].[Tbl_LMS_Lost_Stolen_Book] L     
               
INNER JOIN Tbl_AddBooks A ON L.Book_Id=A.Book_Id              
INNER JOIN dbo.Tbl_BookCategory  BC on BC.Category_Id=A.Category_Id              
INNER JOIN dbo.Tbl_Book_SubCategory  BS on BS.SubCategory_Id=A.SubCategory_Id          
Left JOIN Tbl_Book_Publisher BP ON A.Publisher_Id=BP.Publisher_Id                  
Left JOIN Tbl_Book_Almeria_Rack BAR ON A.Almeria_Rack_Id=BAR.Almeria_Rack_Id             
              
 WHERE Lost_Stolen_Status=0     
    
and  (BC.Category_Name like  ''''''+ @SearchTerm+''%''''    
and  BS.SubCategory_Name like  ''''''+ @SearchTerm1+''%''''      
 )     
      
      
)          
          
               
                            
                
        SELECT      
   [Lost_Stolen_Id],     
   ID,      
   Book_Code,     
   [CategoryId],     
   [Category Name],    
   [SubCategoryId],        
   [SubCategory],    
   [Issue_Book_Id],    
   Book_Serial_No,    
   [Is_LostReturn],     
   [Remarks],    
   [New_or_Fine_Status],    
   [Amount],     
   [Lost_Stolen_Status],    
   Title,    
   [Publisher],    
   Author,      
   Status,      
   RowNumber     
      
FROM                 
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)          
        
END          
          
--IF @SearchTerm is null            
          
 IF ((@SearchTerm is null or @SearchTerm = '''') or (@SearchTerm1 is null or @SearchTerm1 = ''''))         
          
begin          
          
 SET @SqlString=''WITH tempProfile AS     
    
  (SELECT                           
 [Lost_Stolen_Id],                        
    A.Book_Id as ID,        
    A.Book_Code,        
    BC.Category_Id as [CategoryId],        
    BC.Category_Name as [Category Name],        
    BS.SubCategory_Id as [SubCategoryId],         
    BS.SubCategory_Name as SubCategory,            
    [Issue_Book_Id],              
    A.Book_Serial_No,                 
    [Is_LostReturn],                  
    L.[Remarks],                  
    [New_or_Fine_Status],                  
    [Amount],                  
    [Lost_Stolen_Status],                 
    [Book_Title] as Title,                  
    BP.Publisher_Name as [Publisher],        
    A.Book_Author as Author,     
       
Case when A.Book_Id in ((Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0)) and Book_Del_Status=0                  
then ''''Lost''''                  
end as Status,    
    
ROW_NUMBER() over (ORDER BY A.Book_Id DESC) AS RowNumber          
               
  FROM [dbo].[Tbl_LMS_Lost_Stolen_Book] L     
               
INNER JOIN Tbl_AddBooks A ON L.Book_Id=A.Book_Id              
INNER JOIN dbo.Tbl_BookCategory  BC on BC.Category_Id=A.Category_Id              
INNER JOIN dbo.Tbl_Book_SubCategory  BS on BS.SubCategory_Id=A.SubCategory_Id          
Left JOIN Tbl_Book_Publisher BP ON A.Publisher_Id=BP.Publisher_Id                  
Left JOIN Tbl_Book_Almeria_Rack BAR ON A.Almeria_Rack_Id=BAR.Almeria_Rack_Id             
              
 WHERE Lost_Stolen_Status=0     
    
)               
        SELECT    
 [Lost_Stolen_Id],       
   ID,        
   Book_Code,       
   [CategoryId],       
   [Category Name],      
   [SubCategoryId],          
   [SubCategory],      
   [Issue_Book_Id],      
   Book_Serial_No,      
   [Is_LostReturn],       
   [Remarks],      
   [New_or_Fine_Status],      
   [Amount],       
   [Lost_Stolen_Status],      
   Title,      
   [Publisher],      
   Author,        
   Status,        
   RowNumber       
        
FROM                   
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)            
          
end            
            
   EXEC sp_executesql @SqlString     
     
 END                 
              
END
    ')
END
