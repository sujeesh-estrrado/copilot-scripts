IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ToUsers_By_Assignment_Id_And_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_ToUsers_By_Assignment_Id_And_Student_Id]    
@Assignment_Id bigint,  
@Student_Id bigint  
AS  
BEGIN  
Select    
Distinct A.Assignment_Id,  
Stud_Class_Status As Stud_Emp_Class_Status,        
Stud_Class_Id AS Stud_Emp_Class_Id,         
Case When SA.Stud_Class_Status=0 Then C.Candidate_Fname+'' ''+C.Candidate_Mname+'' ''+C.Candidate_Lname         
  When SA.Stud_Class_Status=1 Then CL.Class_Name        
  END AS [User]      
FROM LMS_Tbl_Assignment  A  
INNER JOIN LMS_Tbl_Send_Assignment SA  ON A.Assignment_Id = SA.Assignment_Id    
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=SA.Stud_Class_Id      
LEFT JOIN LMS_Tbl_Class CL On CL.Class_Id=SA.Stud_Class_Id    
where (SA.Assignment_Id=@Assignment_Id  and SA.Stud_Class_Status=0 and Stud_Class_Id=@Student_Id) or  
(SA.Assignment_Id=@Assignment_Id and (Stud_Class_Status=1 and SA.Stud_Class_Id in (Select Class_Id From LMS_Tbl_Student_Class where Student_id=@Student_Id)))  
END
    ')
END
