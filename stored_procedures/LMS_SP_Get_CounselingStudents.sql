IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_CounselingStudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_CounselingStudents] -- 299
@Employee_Id bigint
AS  
BEGIN  

SELECT 
distinct cbd.Batch_Code+''-''+cs.Semester_Code as Batch,cdm.Duration_Mapping_Id,
(SELECT count(Response_Id) from dbo.LMS_Tbl_CounsilQuery cq      
 inner join dbo.LMS_Tbl_CounselingCategory ccc on cc.Category_Id=cq.CategoryId    
 left join dbo.LMS_Tbl_StudentResponse SR on SR.Query_Id=cq.QueryId    
 left join dbo.Tbl_Candidate_Personal_Det cd on cd.Candidate_Id=SR.Candidate_Id 
 where cq.DelStatus=0 and cc.DelStatus=0  and ccc.Duration_Mapping_Id=cc.Duration_Mapping_Id 
) as NoofStudents,cc.Category_Id
from dbo.LMS_Tbl_CounselingCategory cc  
inner join Tbl_Course_Duration_Mapping cdm on cdm.Duration_Mapping_Id=cc.Duration_Mapping_Id  
inner join Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
inner join Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id     
inner join Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id 
inner join Tbl_Student_Semester SS on cc.Duration_Mapping_Id=SS.Duration_Mapping_Id   
inner join LMS_Tbl_CounsilQuery CQ on cc.Category_Id=CQ.CategoryId  
 left join dbo.LMS_Tbl_StudentResponse SR on SR.Query_Id=cq.QueryId      
where Employee_Id=@Employee_Id
END
    ')
END
