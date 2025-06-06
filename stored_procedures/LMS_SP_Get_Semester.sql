IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_Semester]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_Semester]-- 361   
@Candidate_Id bigint  
AS        
BEGIN  
     
SELECT         
Duration_Mapping_Id,        
Semester_Code AS Semester        
FROM Tbl_Course_Duration_Mapping cdm         
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id        
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id         
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id        
inner join  Tbl_Course_Department CD on   cdm.Course_Department_Id=CD.Course_Department_Id     
--inner join Tbl_Student_Semester SS   ON cdm.Duration_Mapping_Id=cdp.Duration_Mapping_Id        
WHERE  cdm.Duration_Mapping_Id in (select distinct Duration_Mapping_Id from Tbl_Student_Semester   
where Student_Semester_Delete_Status=0 and   Candidate_Id=@Candidate_Id )  
END
    ')
END
