IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_student_Batch_and_semester_by_candidateid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_get_student_Batch_and_semester_by_candidateid]  
 @candidateid bigint  
AS  
BEGIN  
   
select TSR.Course_Category_Id,TSR.Department_Id,TSS.Duration_Mapping_Id  
FROM dbo.Tbl_Student_Registration TSR   
LEFT JOIN  dbo.Tbl_Student_Semester TSS on TSS.Candidate_Id=TSR.Candidate_Id  
WHERE TSR.Candidate_Id=@candidateid  AND Student_Semester_Current_Status=1
END      ');
END;
