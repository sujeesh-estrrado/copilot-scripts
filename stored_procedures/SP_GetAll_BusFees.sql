IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_BookDue]')
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Sp_GetAll_BookDue]        
as        
begin        
              
SELECT [Issue_Book_Id]          
      ,BI.[Book_Id] as Bookid          
      ,[Issue_Date] ,
     B.Book_Code         
      ,[Due_Date]          
      ,[Is_Returned]          
      ,[Return_Date]          
      ,[Candidate_or_Employee]          
      ,[Candidate_Employee_Id]          
      ,[Issue_Book_Status]          
      ,[Book_Title]  ,    
      B.Book_Serial_No        
      ,Case When Candidate_or_Employee=0 Then (Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname)           
       Else (Employee_FName+'' ''+Employee_LName) End As Name         
      ,Case When Candidate_or_Employee=0 Then (CP.Candidate_Mob1)           
       Else (Employee_Mobile) End As Mobile      
       ,Case When Candidate_or_Employee=0 Then (CP.Candidate_Email)           
       Else (Employee_Mail) End As Email      
        
      
      
  FROM [Tbl_LMS_Issue_Book] BI          
INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id            
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id        
LEFT JOIN Tbl_Candidate_ContactDetails CP ON CP.Candidate_Id=BI.Candidate_Employee_Id       
LEFT JOIN Tbl_Employee E ON E.Employee_Id=BI.Candidate_Employee_Id          
 WHERE Issue_Book_Status=0  and Is_Returned=0 and Due_Date<getdate()        
end
    ')
END
GO