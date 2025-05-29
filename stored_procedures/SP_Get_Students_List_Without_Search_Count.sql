IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_List_Without_Search_Count]')
    AND type = N'P'
)
BEGIN
    EXEC('
 create procedure [dbo].[SP_Get_Students_List_Without_Search_Count]    
as          
begin          
(SELECT ROW_NUMBER() OVER (ORDER BY ID) AS RowNumber ,    
t.[Student Name],    
t.[Identification Number],    
t.[Blood Group],    
t.[Admission Number],    
t.Gender,    
t.DOB,    
t.Class       
FROM  (SELECT DISTINCT sr.Student_Reg_No as [Reg No],    
    cpd.Candidate_Id as ID,    
    cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As [Student Name],    
    cpd.IdentificationNo as [Identification Number] ,    
    SG.BloodGroup as [Blood Group],     
    sr.Student_Reg_No as [Admission Number],    
    cpd.Candidate_Gender as Gender,    
    cpd.Candidate_Dob as DOB,    
    cc.Course_Category_Name+''-''+D.Department_Name as Class,  
    Batch_Code+''-''+Semester_Code AS Batch,    
    ss.Student_Semester_Current_Status    
    FROM Tbl_Student_Registration sr          
    LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = sr.UserId)        
    left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id        
    inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id             
    inner Join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=cpd.Candidate_Id         
    left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id        
    left join Tbl_Student_Semester ss on ss.Candidate_Id = cpd.Candidate_Id         
    left join Tbl_Course_Duration_Mapping cdm on ss.Duration_Mapping_Id = cdm.Duration_Mapping_Id        
    Inner Join Tbl_Course_Duration_PeriodDetails CP On cdm.Duration_Period_Id=CP.Duration_Period_Id         
    inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id         
    Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id         
    left join Tbl_Course_Department cd on cdm.Course_Department_Id = cd.Course_Department_Id        
    left join Tbl_Course_Category  on cd.Course_Category_Id = cc.Course_Category_Id        
    left join Tbl_Course_Level cl on  cc.Course_level_Id = cl.Course_level_Id         
    left join Tbl_Department D on   cd.Department_Id =  D.Department_Id        
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id) t        
where t.Student_Semester_Current_Status=1     
)        
end
    ')
END;
