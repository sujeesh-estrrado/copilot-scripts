IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Last_Issue_Book_Details_By_BookId]')
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_Get_Last_Issue_Book_Details_By_BookId] 
@Book_Id bigint
AS
BEGIN
SELECT Top 1 [Issue_Book_Id]  
      ,BI.[Book_Id]  
      ,[Issue_Date]  
      ,[Due_Date]  
      ,[Is_Returned]  
      ,[Return_Date]  
      ,[Candidate_or_Employee]  
      ,[Candidate_Employee_Id]  
      ,[Issue_Book_Status]  
,Case When Candidate_or_Employee=0 Then (Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname)   
Else (Employee_FName+'' ''+Employee_LName) End As Name  
FROM [Tbl_LMS_Issue_Book] BI  
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id  
LEFT JOIN Tbl_Employee E ON E.Employee_Id=BI.Candidate_Employee_Id  
WHERE Issue_Book_Status=0 and Book_Id=@Book_Id
ORDER BY Issue_Book_Id DESC
END
    ')
END
