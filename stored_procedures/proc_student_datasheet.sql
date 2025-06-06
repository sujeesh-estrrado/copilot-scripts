IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_student_datasheet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[proc_student_datasheet] --21   
as  
begin  
select  A.Candidate_Fname+'' ''+A.Candidate_Mname+'' ''+A.Candidate_Lname AS Name,
A.*,B.*,CBD.Batch_Code,d.Department_Name as [Class],d.Course_Code 
from dbo.Tbl_Candidate_Personal_Det A  
inner join dbo.Tbl_Candidate_ContactDetails B on A.Candidate_Id=B.Candidate_Id  
inner join dbo.tbl_New_Admission N on N.New_Admission_Id=A.New_Admission_Id
inner join Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=N.Batch_Id
left join dbo.Tbl_Student_Registration  as SR on SR.Candidate_Id=A.Candidate_Id            
left join dbo.Tbl_Course_Category as cc on cc.Course_Category_Id=SR.Course_Category_Id            
left join dbo.Tbl_Department as d on d.Department_Id=SR.Department_Id 
WHERE  d.Department_Status=0 and Candidate_DelStatus=0  
end
    ')
END
