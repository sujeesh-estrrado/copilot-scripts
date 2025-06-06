IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Personal_details_by_student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Get_Personal_details_by_student] --446
@Candidate_Id bigint
as
begin
   
select SS.*,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as StudentName,  
 cc.Candidate_FatherName,      
    
Batch_Code+''-''+Semester_Code AS BatchSemester          
FROM dbo.Tbl_Student_Semester SS   
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id  
inner join dbo.Tbl_Candidate_ContactDetails cc on cc.Candidate_Id=CPD.Candidate_Id
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id       
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id           
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id         
where SS.Candidate_Id=@Candidate_Id and SS.Student_Semester_Delete_Status=0    
end
    ')
END
