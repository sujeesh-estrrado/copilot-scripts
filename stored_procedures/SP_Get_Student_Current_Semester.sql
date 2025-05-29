IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Current_Semester]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_Student_Current_Semester]
@Candidate_Id bigint             
AS                
BEGIN                
SELECT                
cpd.Candidate_Id,            
Tbl_Course_Category.Course_Category_Name+'' ''+D.Department_Name as Class,                
Tbl_Course_Category.Course_Category_Id,                
D.Department_Id,   
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                
Tbl_Course_Category.Course_Category_Id,                
Tbl_Course_Category.Course_Category_Name,                
D.Department_Name,          
Tbl_Student_Semester.Student_Semester_Current_Status as newstatus,          
Tbl_Course_Duration_Mapping.Course_Department_Id,         
Tbl_Course_Duration_Mapping.Duration_Mapping_Id,       
Tbl_Course_Department.Course_Category_Id  ,          
Tbl_Course_Department.Department_Id,          
D.Department_Name as new_dept ,          
Tbl_Course_Category.Course_Category_Name,
cpd.AdmissionType              
                
FROM Tbl_Student_Registration sr                
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id      --          
--inner Join Tbl_Department d on d.Department_Id=sr.Department_Id                
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id           
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id          
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id          
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id          
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id          
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id          
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id             
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id     
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and sr.Candidate_Id=@Candidate_Id                
END
    ');
END;
