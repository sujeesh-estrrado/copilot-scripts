IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Lms_Reservation_ByBookId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Lms_Reservation_ByBookId]  
(@Book_Id bigint)  
AS  
BEGIN  
Select  
row_number() over(partition by Book_Id order by Reservation_Book_Id) as Priority,  
* From  
(  
SELECT  
 R.[Reservation_Book_Id]  
,R.[Book_Id]  
,R.[Candidate_Or_Employee_Id]  
,R.[Candidate_Or_Employee_Status]  
,R.[Reservation_Date]  
,R.[Reservation_Book_Status]  
,[Book_Title]  
  
  
  
,Case When R.Candidate_Or_Employee_Status=0 Then (Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname)  
Else (Employee_FName+'' ''+Employee_LName) End As [Name],  
Case  
When(((Select Top 1 Issue_Reservation_Mapping_Id From Tbl_Lms_Issue_Reservation_Book_Mapping  
Where Reservation_Book_Id=R.Reservation_Book_Id) is null) AND  
((Select top 1 Return_Book_Id From Tbl_LMS_Return_Book Where Issue_Book_Id=(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)) is not null))  
AND  
((Select top 1 Return_Book_Id From Tbl_LMS_Return_Book Where Issue_Book_Id=(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)) is not null)  
and  
Isnull(  
(Select Top 1 DATEDIFF(day, Return_Date,GETDATE())  
 from Tbl_LMS_Return_Book  
 where Issue_Book_Id=  
(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book  
Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)),0)<  
Case when R.Candidate_Or_Employee_Status=0  
Then (Select top 1 Reservation_Days from Tbl_LMS_Reservation_Master Where Candidate_Or_Employee_Status=0 and Reservation_Master_Status=0 order by Reservation_Master_Id desc)  
Else (Select top 1 Reservation_Days from Tbl_LMS_Reservation_Master Where Candidate_Or_Employee_Status=1 and Reservation_Master_Status=0 order by Reservation_Master_Id desc) End  
Then ''1''  
Else ''0'' End AS IssueStatus,  
  
  
  
  
Case  
When(Select Top 1 Issue_Reservation_Mapping_Id From Tbl_Lms_Issue_Reservation_Book_Mapping  
Where Reservation_Book_Id=R.Reservation_Book_Id) is not null Then ''Issued''  
When(Select Top 1 Return_Book_Id From Tbl_LMS_Return_Book Where Issue_Book_Id=(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)) is null Then ''Not in Stock''  
When((Select  Top 1  Return_Book_Id From Tbl_LMS_Return_Book Where Issue_Book_Id=(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)) is not null)  
and  
Isnull(  
(Select Top 1 DATEDIFF(day, Return_Date,GETDATE())  
 from Tbl_LMS_Return_Book  
 where Issue_Book_Id=  
(Select top 1 Issue_Book_Id From Tbl_LMS_Issue_Book  
Where Book_Id=R.[Book_Id] and Issue_Book_Status=0 order by Issue_Book_Id desc)),0)>  
Case when R.Candidate_Or_Employee_Status=0  
Then (Select top 1 Reservation_Days from Tbl_LMS_Reservation_Master Where Candidate_Or_Employee_Status=0 and Reservation_Master_Status=0 order by Reservation_Master_Id desc)  
Else (Select top 1 Reservation_Days from Tbl_LMS_Reservation_Master Where Candidate_Or_Employee_Status=1 and Reservation_Master_Status=0 order by Reservation_Master_Id desc) End  
Then ''Expired''  
Else ''In Stock'' End AS Status  
  
  
  
FROM [Tbl_Lms_Reservation_Books] R  
INNER JOIN Tbl_AddBooks A ON R.Book_Id=A.Book_Id  
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=R.Candidate_Or_Employee_Id  
LEFT JOIN Tbl_Employee E ON E.Employee_Id=R.Candidate_Or_Employee_Id  
WHERE Reservation_Book_Status=0  
and R.[Book_Id]=@Book_Id  
 ) Tmp  
Where Status<>''Issued''  
END
    ')
END
