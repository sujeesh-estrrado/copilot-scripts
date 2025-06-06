IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Weeded_Book]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Get_All_Weeded_Book]        
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
   [Book_Weeding_Id],      
   B.Book_Id as ID,      
   BC.Category_Id as [CategoryId],      
   BC.Category_Name as [Category Name],      
   BS.SubCategory_Id as [SubCategoryId],      
   BS.SubCategory_Name as SubCategory,      
   B.Book_Serial_No,      
   B.Book_Code,      
   [Given_Date],      
   [Expected_Return_Date],      
   [Is_Returned],      
   [Return_Date],      
   [Book_Weeding_Status],      
   [Book_Title] as Title,      
   BP.Publisher_Name as [Publisher],      
   B.Book_Author as Author,       
         
Case when B.Book_Id in ((Select Book_Id From [Tbl_LMS_Book_Weeding] Where Book_Weeding_Status=0)) and Book_Del_Status=0       
                   
then ''''Weeding''''         
                 
end as Status,      
      
ROW_NUMBER() over (ORDER BY B.Book_Id DESC) AS RowNumber        
                  
 FROM [Tbl_LMS_Book_Weeding]  BW       
               
INNER JOIN Tbl_AddBooks B ON BW.Book_Id=B.Book_Id                
INNER JOIN dbo.Tbl_BookCategory  BC on BC.Category_Id=B.Category_Id              
INNER JOIN dbo.Tbl_Book_SubCategory  BS on BS.SubCategory_Id=B.SubCategory_Id           
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id                    
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id              
WHERE Book_Weeding_Status=0    
and  (BC.Category_Name like  ''''''+ @SearchTerm+''%''''    
and  BS.SubCategory_Name like  ''''''+ @SearchTerm1+''%''''      
 )           
)            
          
        SELECT        
   [Book_Weeding_Id],      
   ID,      
   [CategoryId],      
   [Category Name],      
   [SubCategoryId],      
   SubCategory,      
   Book_Serial_No,      
   Book_Code,      
   [Given_Date],      
   [Expected_Return_Date],      
   [Is_Returned],      
   [Return_Date],      
   [Book_Weeding_Status],      
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
   [Book_Weeding_Id],      
   B.Book_Id as ID,      
   BC.Category_Id as [CategoryId],      
   BC.Category_Name as [Category Name],      
   BS.SubCategory_Id as [SubCategoryId],      
   BS.SubCategory_Name as SubCategory,      
   B.Book_Serial_No,      
   B.Book_Code,      
   [Given_Date],      
   [Expected_Return_Date],      
   [Is_Returned],      
   [Return_Date],      
   [Book_Weeding_Status],      
 [Book_Title] as Title,      
   BP.Publisher_Name as [Publisher],      
   B.Book_Author as Author,       
         
Case when B.Book_Id in ((Select Book_Id From [Tbl_LMS_Book_Weeding] Where Book_Weeding_Status=0)) and Book_Del_Status=0       
             
then ''''Weeding''''         
                 
end as Status,      
      
ROW_NUMBER() over (ORDER BY B.Book_Id DESC) AS RowNumber        
                  
 FROM [Tbl_LMS_Book_Weeding]  BW       
               
INNER JOIN Tbl_AddBooks B ON BW.Book_Id=B.Book_Id                
INNER JOIN dbo.Tbl_BookCategory  BC on BC.Category_Id=B.Category_Id              
INNER JOIN dbo.Tbl_Book_SubCategory  BS on BS.SubCategory_Id=B.SubCategory_Id           
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id                    
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id              
WHERE Book_Weeding_Status=0       
            
 )      
          
          
        SELECT        
   [Book_Weeding_Id],      
   ID,      
   [CategoryId],      
   [Category Name],      
   [SubCategoryId],      
   SubCategory,      
   Book_Serial_No,      
   Book_Code,      
   [Given_Date],      
   [Expected_Return_Date],      
   [Is_Returned],      
   [Return_Date],      
   [Book_Weeding_Status],      
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
