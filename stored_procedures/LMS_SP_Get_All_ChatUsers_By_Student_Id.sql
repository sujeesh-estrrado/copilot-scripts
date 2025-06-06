IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_ChatUsers_By_Student_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_All_ChatUsers_By_Student_Id]          
@Student_Id bigint          
AS          
BEGIN          
SELECT            
Distinct Employee_id As UserId,             
E.Employee_Fname+'' ''+E.EMployee_Lname As UserName,    
''Employee'' AS UserType,  
User_Img  As UserImage             
From LMS_Tbl_Class c      
Inner Join LMS_Tbl_Student_Class sc On sc.Class_Id=c.Class_Id           
Inner Join LMS_Tbl_Emp_Class ec On sc.Class_Id=ec.Class_Id            
Inner Join Tbl_Employee E On ec.Emp_Id=E.Employee_id  
Left Join  LMS_Tbl_User_Image Uimg On Uimg.User_Id=E.Employee_id and Uimg.User_Status=1       
Where c.Active_Status=1 and c.Delete_Status=0 and ec.Active_Status=1            
and c.Class_Id<>1 and sc.Student_id=@Student_Id      
    
--UNION    
--    
--SELECT      
--Distinct Candidate_Id As UserId,       
--Candidate_Fname+'''' ''''+Candidate_Lname As UserName,    
--''''Student'''' AS UserType,  
--User_Img  As UserImage     
--From LMS_Tbl_Class c      
--Inner Join LMS_Tbl_Student_Class sc on c.Class_Id=sc.Class_Id      
--Inner Join Tbl_Candidate_Personal_Det cp On sc.Student_id=cp.Candidate_Id   
--Left Join  LMS_Tbl_User_Image Uimg On Uimg.User_Id=cp.Candidate_Id and Uimg.User_Status=0      
--Where c.Active_Status=1 and c.Delete_Status=0 and sc.Approval_Status=1 and sc.Status=0      
--and c.Class_Id<>1 and sc.Student_id=@Student_Id and cp.Candidate_Id<>@Student_Id    
     
     
END
    ')
END
