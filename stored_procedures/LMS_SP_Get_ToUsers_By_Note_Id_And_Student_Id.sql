IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ToUsers_By_Note_Id_And_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_ToUsers_By_Note_Id_And_Student_Id]  
@Note_Id bigint,
@Student_Id bigint
AS
BEGIN
Select  
Distinct N.Note_Id,
Stud_Emp_Class_Status,  
Stud_Emp_Class_Id,   
Case When SN.Stud_Emp_Class_Status=0 Then C.Candidate_Fname+'' ''+C.Candidate_Mname+'' ''+C.Candidate_Lname   
  When SN.Stud_Emp_Class_Status=2 Then CL.Class_Name  
     Else E.Employee_Fname+'' ''+E.EMployee_Lname END AS [User]  
FROM LMS_Tbl_Notes  N
INNER JOIN LMS_Tbl_Send_Notes SN  ON N.Note_Id = SN.Note_Id  
LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id=SN.Stud_Emp_Class_Id    
LEFT JOIN LMS_Tbl_Class CL On CL.Class_Id=SN.Stud_Emp_Class_Id  
LEFT JOIN Tbl_Employee E On E.Employee_Id=SN.Stud_Emp_Class_Id  
where (SN.Note_Id=@Note_Id  and SN.Stud_Emp_Class_Status=0 and Stud_Emp_Class_Id=@Student_Id) or
(SN.Note_Id=@Note_Id and (Stud_Emp_Class_Status=2 and SN.Stud_Emp_Class_Id in (Select Class_Id From LMS_Tbl_Student_Class where Student_id=@Student_Id)))
END
    ')
END
