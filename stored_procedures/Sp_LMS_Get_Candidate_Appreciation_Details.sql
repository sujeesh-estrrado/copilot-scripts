IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_LMS_Get_Candidate_Appreciation_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_LMS_Get_Candidate_Appreciation_Details]     
AS    
BEGIN    
select distinct CAD.Cand_App_Id,cpd.Candidate_Id,cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,Tbl_Course_Category.Course_Category_Name+''-''+D.Department_Name as Class,CAD.Appreciate_Status,CAD.Notify_Date     
FROM Tbl_Student_Registration sr                             
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = sr.UserId)                                           
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                            
inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                      
left Join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=cpd.Candidate_Id                  
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                       
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                      
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                           
Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                           
--inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id         
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=CP.Batch_Id                          
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id                                    
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id                                      
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id                                      
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                                      
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id                                         
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id                                           
left join dbo.Tbl_Candidate_EducationDetails ED on ED.Candidate_Id= cpd.Candidate_Id                
left join Tbl_Candidate_University_Regno CUR ON CUR.Candidate_Id=cpd.Candidate_Id        
inner join Tbl_Candidate_Appreciate_Details CAD on CAD.Candidate_Id = CPD.Candidate_Id where CAD.Status=1   
End    
    
    
--select * from Tbl_Candidate_Appreciate_Details    
--select * from [dbo].[Tbl_Candidate_Personal_Det]    
--select * from [dbo].[Tbl_Candidate_ContactDetails]    
--select * from Tbl_Student_Registration  
    ');
END;
