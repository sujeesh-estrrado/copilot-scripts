IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Users_By_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Users_By_Student_Id]   
@Student_id bigint,    
@Search varchar(200)      
AS      
BEGIN      
    
SELECT      
Distinct Candidate_Id AS UserId,       
Candidate_Fname+'' ''+Candidate_Lname As UserName,    
''Student'' As UserType,
User_Img  As UserImage        
From LMS_Tbl_Class c      
Inner Join LMS_Tbl_Student_Class sc on c.Class_Id=sc.Class_Id      
Inner Join Tbl_Candidate_Personal_Det cp On sc.Student_id=cp.Candidate_Id 
Left Join  LMS_Tbl_User_Image Uimg On Uimg.User_Id=cp.Candidate_Id and Uimg.User_Status=0       
Where c.Active_Status=1 and c.Delete_Status=0 and sc.Approval_Status=1 and sc.Status=0      
and sc.Student_id=@Student_id and  Candidate_Id<>@Student_id and Candidate_Fname+'' ''+Candidate_Lname like @Search+''%''    
UNION     
SELECT      
Distinct Employee_id AS UserId,       
E.Employee_Fname+'' ''+E.EMployee_Lname As UserName,    
''Faculty'' As UserType,
User_Img  As UserImage       
From LMS_Tbl_Class c      
Inner Join LMS_Tbl_Emp_Class ec On c.Class_Id=ec.Class_Id      
Inner Join LMS_Tbl_Student_Class sc on ec.Class_Id=sc.Class_Id     
Inner Join Tbl_Employee E On ec.Emp_Id=E.Employee_id
Left Join  LMS_Tbl_User_Image Uimg On Uimg.User_Id=E.Employee_id and Uimg.User_Status=1      
Where c.Active_Status=1 and c.Delete_Status=0 and ec.Active_Status=1      
and sc.Student_id=@Student_id   and E.Employee_Fname+'' ''+E.EMployee_Lname like @Search+''%''    
END
    ')
END
