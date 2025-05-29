IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_AbsentStudents_For_DutyLeave_ByPeriod]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_AbsentStudents_For_DutyLeave_ByPeriod]          
(@Absent_Date datetime,  
 @Duration_Mapping_Id bigint,  
 @Class_Timings_Id bigint)          
AS          
BEGIN          
SELECT          
CP.Candidate_Fname+'' ''+ CP.Candidate_Lname AS CandidateName,        
CR.RollNumber AS RollNo,        
SA.*          
FROM dbo.Tbl_Student_Absence SA          
INNER JOIN dbo.Tbl_Candidate_Personal_Det CP on CP.Candidate_Id=SA.Candidate_Id         
LEFT JOIN  Tbl_Candidate_RollNumber CR on CR.Candidate_Id=SA.Candidate_Id        
WHERE SA.Absent_Date=@Absent_Date and SA.Duration_Mapping_Id=@Duration_Mapping_Id and Class_Timings_Id=@Class_Timings_Id and CP.Candidate_DelStatus=0        
and Absent_Type<>''DL''           
END
    ')
END
