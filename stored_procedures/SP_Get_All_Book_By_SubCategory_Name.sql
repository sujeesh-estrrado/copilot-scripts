IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Book_By_SubCategory_Name]')
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Get_All_Book_By_SubCategory_Name]  
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
B.Book_Id as ID,  
B.Book_Author as Author,     
B.Book_Code,       
BC.Category_Name as [Category Name],                   
B.Book_Serial_No,              
BSC.SubCategory_Name as [SubCategory],               
BP.Publisher_Name as [Publisher],             
B.Book_Title as Title,                     
        
Case when B.Book_Id not in ((Select Book_Id From Tbl_LMS_Issue_Book Where Issue_Book_Status=0 and Is_Returned=0)              
union (Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0 and Is_LostReturn=0)              
union (Select Book_Id From Tbl_LMS_Book_Weeding Where Book_Weeding_Status=0 and Is_Returned=0)) and Book_Del_Status=0              
then ''''Available''''              
else ''''Reserve'''' end as Status,  
  
ROW_NUMBER() over (ORDER BY Book_Id DESC) AS RowNumber             
              
From dbo.Tbl_AddBooks B              
              
              
Left Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id              
Left JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id              
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id              
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id              
              
              
              
where              
Book_Del_Status=0  
  
and  (BSC.SubCategory_Name like  ''''''+ @SearchTerm+''%''''  
)      
      
           
        )                 
            
        SELECT  
ID,  
Author,  
Book_Code,  
[Category Name],  
Book_Serial_No,  
[SubCategory],  
[Publisher],  
Title,  
Status,  
RowNumber  
  
FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT                       
B.Book_Id as ID,  
B.Book_Author as Author,     
B.Book_Code,       
BC.Category_Name as [Category Name],                   
B.Book_Serial_No,              
BSC.SubCategory_Name as [SubCategory],               
BP.Publisher_Name as [Publisher],             
B.Book_Title as Title,                     
        
Case when B.Book_Id not in ((Select Book_Id From Tbl_LMS_Issue_Book Where Issue_Book_Status=0 and Is_Returned=0)              
union (Select Book_Id From Tbl_LMS_Lost_Stolen_Book Where Lost_Stolen_Status=0 and Is_LostReturn=0)              
union (Select Book_Id From Tbl_LMS_Book_Weeding Where Book_Weeding_Status=0 and Is_Returned=0)) and Book_Del_Status=0              
then ''''Available''''              
else ''''Reserve'''' end as Status,  
  
ROW_NUMBER() over (ORDER BY Book_Id DESC) AS RowNumber             
              
From dbo.Tbl_AddBooks B              
              
              
Left Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id              
Left JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id         
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id              
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id              
              
              
              
where              
Book_Del_Status=0  
  
and  (BSC.SubCategory_Name like  ''''''+ @SearchTerm+''%''''         
  
)      
      
           
        )                 
            
        SELECT  
ID,  
Author,  
Book_Code,  
[Category Name],  
Book_Serial_No,  
[SubCategory],  
[Publisher],  
Title,  
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
GO