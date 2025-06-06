IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Candidate_Profile_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[LMS_SP_Get_All_Candidate_Profile_Details]-- 412       
   @Candidate_Id bigint    
AS                    
BEGIN          
    
    
    
SELECT  distinct                                           
cpd.Candidate_Id,cpd.Candidate_Gender as Gender,cpd.Active_Status,cpd.Candidate_Dob as DateOfBirth,    
ccd.Candidate_Mob1 as Mobile,ccd.Candidate_Email as Email,ccd.Candidate_PermAddress as Address,    
 ccd.Candidate_FatherName as Father,ccd.Candidate_MotherName as Mother,ccd.Candidate_Guardian_Mob as GuardianNumber,                           
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,               
Batch_Code+''-''+Semester_Code AS Class           
FROM Tbl_Student_Registration sr                                       
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                                      
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                                 
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                                
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                                     
Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                                     
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=CP.Batch_Id                                    
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id     
INNER JOIN   Tbl_Candidate_ContactDetails ccd on cpd.Candidate_Id=ccd.Candidate_Id             
     
 where cpd.Candidate_Id=@Candidate_Id   and cpd.Candidate_DelStatus=0             
 END    
 --select * from dbo.Tbl_Candidate_Personal_Det


    ')
END
