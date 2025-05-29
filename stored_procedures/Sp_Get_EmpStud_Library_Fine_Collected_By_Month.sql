IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_EmpStud_Library_Fine_Collected_By_Month]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_EmpStud_Library_Fine_Collected_By_Month]    
    
(@FromDate Datetime,     
                 
@ToDate Datetime,

@Candidate_or_Employee bit)    
    
AS     
    
BEGIN   
  
SELECT  BI.[Issue_Book_Id]  
              
,BI.[Book_Id] 

,B.Book_Title
        
,RB.Return_Book_Id
 
,BI.Issue_Date
      
,RB.[Return_Date] 
               
,BI.[Candidate_or_Employee] 
               
,BI.[Candidate_Employee_Id]

,RF.Fine_Amount
                
,Case When Candidate_or_Employee=0 Then (Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname) 
                
Else (Employee_FName+'' ''+Employee_LName) End As Name 
            
 
FROM         Tbl_LMS_Issue_Book BI

INNER JOIN Tbl_AddBooks B ON BI.Book_Id=B.Book_Id   
 
INNER JOIN  Tbl_LMS_Return_Book RB ON BI.Issue_Book_Id = RB.Issue_Book_Id 

INNER JOIN Tbl_LMS_Return_Fine RF ON RB.Return_Book_Id = RF.Return_Book_Id

LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=BI.Candidate_Employee_Id 
             
LEFT JOIN Tbl_Student_Registration SR ON SR.Candidate_Id=C.Candidate_Id                
             
LEFT JOIN Tbl_Employee E ON E.Employee_Id=BI.Candidate_Employee_Id 
  
  
  
  
WHERE RB.Return_Date between @FromDate and @ToDate and  Candidate_or_Employee=@Candidate_or_Employee 

    
END

	');
END;
