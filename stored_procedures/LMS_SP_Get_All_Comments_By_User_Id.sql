IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Comments_By_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_All_Comments_By_User_Id] 
@Assignment_Id bigint,  
@Stud_Emp_Id bigint 
AS    
    
BEGIN    
SELECT   AC.Assignment_Id,  
         AC.Assignment_Comments,  
   AC.Stud_Emp_Status,  
   AC.Stud_Emp_Id,  
   AC.Assignment_Comment_Date,  
   AC.Status,  
  
Case   
--When AC.Stud_Emp_Status =@Stud_Emp_Status AND AC.Stud_Emp_Id = @Stud_Emp_Id THEN ''''ME''''   
WHEN AC.Stud_Emp_Status = 0 THEN C.Candidate_Fname+'' ''+C.Candidate_Mname+'' ''+C.Candidate_Lname  
When AC.Stud_Emp_Status = 1 THEN  E.Employee_Fname+'' ''+E.EMployee_Lname   
Else '''' END AS [USER]  
FROM LMS_Tbl_Assignment_Comments AC  
INNER JOIN Tbl_Candidate_Personal_Det C ON AC.Stud_Emp_Id = C.Candidate_Id  
INNER JOIN Tbl_Employee E ON AC.Stud_Emp_Id = E.Employee_Id  
WHERE (Assignment_Id=@Assignment_Id AND Stud_Emp_Id=@Stud_Emp_Id AND Stud_Emp_Status=0)
 or(Assignment_Id=@Assignment_Id  and To_Stud_id = @Stud_Emp_Id)
       
END
    ')
END
