IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Candidate_Performance_Details_BatchWise]') 
    AND type = N'P'
)
BEGIN
    EXEC('
         
CREATE procedure [dbo].[LMS_SP_Get_All_Candidate_Performance_Details_BatchWise]  -- 0            
@Duration_Mapping_Id bigint         
AS                  
BEGIN        
--if(@Duration_Mapping_Id>0)    
--begin              
SELECT distinct                                          
cpd.Candidate_Id,ccd.Candidate_Mob1 as Mobile,ccd.Candidate_Email as Email,                          
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,             
Batch_Code+''-''+Semester_Code AS Class ,Tbl_Student_Semester.Duration_Mapping_Id         
FROM Tbl_Student_Registration sr                                     
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                                    
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                               
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                              
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                                   
Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                                   
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=CP.Batch_Id                                  
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id       
INNER JOIN   Tbl_Candidate_ContactDetails ccd on cpd.Candidate_Id=ccd.Candidate_Id         
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and cpd.Candidate_DelStatus=0               
and Tbl_Student_Semester.Duration_Mapping_Id=@Duration_Mapping_Id        
--End     
--Else    
--begin    
--SELECT distinct                                          
--cpd.Candidate_Id,ccd.Candidate_Mob1 as Mobile,ccd.Candidate_Email as Email,                          
--cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,             
--Batch_Code+''-''+Semester_Code AS Class ,Tbl_Student_Semester.Duration_Mapping_Id         
--FROM Tbl_Student_Registration sr                                     
--left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                                    
--left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                               
--left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                              
--left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                                   
--Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                                   
--inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=CP.Batch_Id                                  
--Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id       
--INNER JOIN   Tbl_Candidate_ContactDetails ccd on cpd.Candidate_Id=ccd.Candidate_Id        
--End    
END            
          
          
    --select * from Tbl_Student_Semester       
    --select * from dbo.Tbl_Candidate_ContactDetails      
    --select * from Tbl_Candidate_Personal_Det

    ')
END
