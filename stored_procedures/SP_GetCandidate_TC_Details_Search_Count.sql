IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetCandidate_TC_Details_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetCandidate_TC_Details_Search_Count]   
  
@SearchTerm varchar(100)   
                                 
AS                                  
BEGIN     
                                 
SELECT ROW_NUMBER() over (ORDER BY SR.Student_Reg_No DESC) AS RowNumber ,  
  
CP.Candidate_Fname+'' ''+CP.Candidate_Mname+'' ''+CP.Candidate_Lname as [Student Name],  
   
SR.Student_Reg_No as [Admission Number],   
  
CP.Candidate_Gender as Gender,  
   
CP.IdentificationNo as [ID No] ,  
               
SR.Candidate_Id as ID,  
         
SG.BloodGroup as [Blood Group],  
  
CP.Candidate_Dob as DOB,  
         
Tbl_Course_Category.Course_Category_Name+'' ''+D.Department_Name as Class,  
                  
P.Candidate_Telephone as Telephone,   
                 
P.Candidate_Email as Email,  
                  
t.TC_No as [TC No],  
  
t.TC_Issue_Date as [TC Date],  
  
t.TC_Relieving_Date as [Date of Leaving]     
             
                  
From dbo.Tbl_Student_Registration SR                  
                  
LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP  on CP.Candidate_Id=SR.Candidate_Id    
                
LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD on CD.Candidate_Id=CP.Candidate_Id   
                 
LEFT JOIN dbo.Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id                  
                
LEFT JOIN dbo.Tbl_Candidate_ContactDetails P on P.Candidate_Id=CP.Candidate_Id   
                 
left join dbo.Tbl_Student_TC_Details t on t.Candidate_Id=CP.Candidate_Id   
                 
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = CP.Candidate_Id  
            
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id   
           
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id   
           
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id   
           
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id  
            
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id   
              
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CP.Candidate_Id                   
            
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and CP.Candidate_DelStatus=0    
  
and  (CP.Candidate_Fname+'' ''+CP.Candidate_Mname+'' ''+CP.Candidate_Lname like  ''''+ @SearchTerm+''%''       
      
or SR.Student_Reg_No like  ''''+ @SearchTerm+''%''    
  
or  CP.Candidate_Gender like  ''''+ @SearchTerm+''%''   
  
or  CP.IdentificationNo like  ''''+ @SearchTerm+''%''   
  
or  SG.BloodGroup like  ''''+ @SearchTerm+''%''   
  
or  CP.Candidate_Dob like  ''''+ @SearchTerm+''%''   
  
or  Tbl_Course_Category.Course_Category_Name+'' ''+D.Department_Name like  ''''+ @SearchTerm+''%''   
  
or  P.Candidate_Telephone like  ''''+ @SearchTerm+''%''   
  
or  P.Candidate_Email like  ''''+ @SearchTerm+''%''   
  
or  t.TC_No like  ''''+ @SearchTerm+''%''   
  
or  t.TC_Issue_Date like  ''''+ @SearchTerm+''%''   
  
or  t.TC_Relieving_Date like  ''''+ @SearchTerm+''%''       
      
)       
        
        
    
        
end');
END;
