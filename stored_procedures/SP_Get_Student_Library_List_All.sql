IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Library_List_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_Student_Library_List_All]             
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
  
B.Book_Id as ID   
   
,[Issue_Book_Id]                  
  
,B.Book_Author as Author  
  
,B.Book_Code   
   
,BC.Category_Name as [Category Name]  
  
,B.Book_Serial_No  
  
,BSC.SubCategory_Name as [SubCategory]  
  
,BC.Category_Id as [CategoryId]  
  
,BSC.SubCategory_Id as [SubCategoryId]  
  
,BP.Publisher_Name as [Publisher]  
  
,B.Book_Title  
  
,[Issue_Date]   
                
,[Due_Date]           
        
        
,CASE WHEN [Is_Returned] = 1 THEN CONVERT(VARCHAR(10),[Return_Date],3) ELSE '''''''' END AS ReturnDate_new               
                    
,[Return_Date]   
                 
,[Candidate_or_Employee]  
                  
,[Candidate_Employee_Id]  
                  
,[Issue_Book_Status]                
               
,[Is_Returned]  
                 
,Case When Candidate_or_Employee=0 Then (Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname) End As Name                   
            
,Case When Is_Returned=0 Then ''''Not Returned''''  
                   
Else ''''Returned'''' End As Status    
   
,Case When Candidate_or_Employee=0 Then (CC.Course_Category_Name+''''-''''+D.Department_Name) End As Department  
  
,ROW_NUMBER() over (ORDER BY BI.Book_Id) AS RowNumber                    
               
                
                
  FROM [Tbl_LMS_Issue_Book] BI    
  
                
INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id            
          
Left Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id   
                 
Left JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id    
                
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id   
                 
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id           
                          
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id   
               
left join Tbl_Student_Registration SR on SR.Candidate_Id=C.Candidate_Id   
                 
left join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id   
                
left join Tbl_Department D on D.Department_Id=SR.Department_Id   
  
where Candidate_or_Employee=''''false'''' and  
  
  
 (Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname like  ''''''+ @SearchTerm+''%''''  
  
or  Student_Reg_No like  ''''''+ @SearchTerm+''%''''         
      
  
   
      
)      
      
           
        )                 
            
        SELECT             
 ID    
,[Issue_Book_Id]                  
,Author  
,Book_Code    
,[Category Name]  
,Book_Serial_No  
,[SubCategory]  
,[CategoryId]  
,[SubCategoryId]  
,[Publisher]  
,Book_Title  
,[Issue_Date]                
,[Due_Date]                      
,ReturnDate_new                                 
,[Return_Date]                 
,[Candidate_or_Employee]                  
,[Candidate_Employee_Id]                  
,[Issue_Book_Status]                             
,[Is_Returned]                 
,Name                             
,Status     
,Department  
,RowNumber                                  
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT   
  
B.Book_Id as ID   
   
,[Issue_Book_Id]                  
  
,B.Book_Author as Author  
  
,B.Book_Code   
   
,BC.Category_Name as [Category Name]  
  
,B.Book_Serial_No  
  
,BSC.SubCategory_Name as [SubCategory]  
  
,BC.Category_Id as [CategoryId]  
  
,BSC.SubCategory_Id as [SubCategoryId]  
  
,BP.Publisher_Name as [Publisher]  
  
,B.Book_Title  
  
,[Issue_Date]   
                
,[Due_Date]                
        
,CASE WHEN [Is_Returned] = 1 THEN CONVERT(VARCHAR(10),[Return_Date],3) ELSE '''''''' END AS ReturnDate_new               
                    
,[Return_Date]   
                 
,[Candidate_or_Employee]  
                  
,[Candidate_Employee_Id]  
                  
,[Issue_Book_Status]   
               
,[Is_Returned]  
                 
,Case When Candidate_or_Employee=0 Then (Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname) End As Name                   
            
,Case When Is_Returned=0 Then ''''Not Returned''''  
                   
Else ''''Returned'''' End As Status    
   
,Case When Candidate_or_Employee=0 Then (CC.Course_Category_Name+''''-''''+D.Department_Name) End As Department  
,ROW_NUMBER() over (ORDER BY BI.Book_Id) AS RowNumber                    
               
                
                
  FROM [Tbl_LMS_Issue_Book] BI    
  
                
INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id            
          
Left Join Tbl_BookCategory BC ON B.Category_Id=BC.Category_Id   
                 
Left JOIN Tbl_Book_SubCategory BSC ON B.SubCategory_Id=BSC.SubCategory_Id    
                
Left JOIN Tbl_Book_Publisher BP ON B.Publisher_Id=BP.Publisher_Id   
                 
Left JOIN Tbl_Book_Almeria_Rack BAR ON B.Almeria_Rack_Id=BAR.Almeria_Rack_Id           
                          
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id   
               
left join Tbl_Student_Registration SR on SR.Candidate_Id=C.Candidate_Id   
                 
left join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id   
                
left join Tbl_Department D on D.Department_Id=SR.Department_Id   
  
where Candidate_or_Employee=''''false''''                                                                                      
                                                                                                        
          
        )                 
            
        SELECT             
    ID    
,[Issue_Book_Id]                  
,Author  
,Book_Code    
,[Category Name]  
,Book_Serial_No  
,[SubCategory]  
,[CategoryId]  
,[SubCategoryId]  
,[Publisher]  
,Book_Title  
,[Issue_Date]                
,[Due_Date]                      
,ReturnDate_new                                 
,[Return_Date]                 
,[Candidate_or_Employee]                  
,[Candidate_Employee_Id]                  
,[Issue_Book_Status]                              
,[Is_Returned]                 
,Name                             
,Status     
,Department  
,RowNumber                                  
        FROM             
            tempProfile  WHERE RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END

    ')
END
