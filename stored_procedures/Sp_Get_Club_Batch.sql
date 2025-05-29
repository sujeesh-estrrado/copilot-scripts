IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Club_Batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Club_Batch]  
AS  
BEGIN  
    select cm.*,cbd.Batch_Code+''''+cs.Semester_Code as BatchName from dbo.LMS_Tbl_ClubBatch_Mapping cm
    inner join Tbl_Course_Duration_Mapping cdm on cdm.Duration_Mapping_Id=cm.Batch_Id          
    INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
    INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id           
    INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id where Status=0  
END
    ');
END;
