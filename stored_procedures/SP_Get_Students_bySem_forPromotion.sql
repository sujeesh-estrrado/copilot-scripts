IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_bySem_forPromotion]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Get_Students_bySem_forPromotion]   --1454        
(                 
@Intakeid bigint,        
@ProgrammeId bigint,        
@SEMESTER_NO bigint         
)          
AS                    
BEGIN                    
    SELECT                     
    ROW_NUMBER() OVER(ORDER BY CONCAT(Candidate_Fname, '' '', Candidate_Lname) ASC) AS RollNo,                    
    S.Student_Semester_Id,                    
    S.Candidate_Id,                    
    S.Duration_Mapping_Id,          
    CONCAT(Candidate_Fname, '' '', Candidate_Lname, ''('', AdharNumber, '')'') AS CandidateName        
    --concat(''IC/passport: '', '' '', AdharNumber) AS AdharNumber,
    --concat(''Student ID: '', '' '', IDMatrixNo) AS IDMatrixNo                   
               
    FROM Tbl_Student_Semester S                    
    INNER JOIN Tbl_Candidate_Personal_Det C ON S.Candidate_Id = C.Candidate_Id           
    LEFT JOIN Tbl_New_Admission NA ON NA.New_Admission_Id = C.New_Admission_Id  
    LEFT JOIN Tbl_Course_Duration_PeriodDetails PD ON PD.Duration_Period_Id = S.Duration_Period_Id        

    WHERE     
    --Student_Semester_Current_Status = 1 and     
    --Student_Semester_Delete_Status = 0 and Candidate_DelStatus = 0         
    (Active = 3 OR Active = 2 OR Active = 1) 
    AND PD.Batch_Id = @Intakeid        
    AND NA.Department_Id = @ProgrammeId         
    AND S.SEMESTER_NO = @SEMESTER_NO           
                   
    ORDER BY CandidateName ASC            
                 
END 
    ')
END;
