IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetCandidatePromtionRecords_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         
CREATE procedure [dbo].[GetCandidatePromtionRecords_Search_Count]      
(      
@SearchTerm  varchar(100)      
)      
      
as      
      
begin      
      
SELECT ROW_NUMBER() over (ORDER BY CPD.Candidate_Id) AS RowNumber ,CPD.Candidate_Id as ID,                                 
 CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                                 
        
                                    
                               
                               
 CCat.Course_Category_Name as [Category]    ,   
  
 cbd.Batch_Code as Batch                                        
                                       
FROM Tbl_Candidate_Personal_Det  CPD                                      
                       
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id               
left join               
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id    and  SS.Student_Semester_Delete_Status=0 and               
ss.student_semester_current_status=1           
left JOIN                   
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                   
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                      
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                       
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                     
              
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                               
                                   
                              
                                  
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                   
                                   
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                      
                                    
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                     
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                     
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                               
                                   
                                  
                                        
where CPD.Candidate_DelStatus=0       
      
      
and  (CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname like  @SearchTerm +''%''       
      
or CCat.Course_Category_Name like  @SearchTerm+''%'' or  cbd.Batch_Code like  @SearchTerm +''%'' )      
      
end
    ')
END
