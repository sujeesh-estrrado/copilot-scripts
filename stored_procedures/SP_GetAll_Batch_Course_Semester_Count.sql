IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Batch]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[LMS_SP_GetAll_Batch] -- 3      
@Department_Id bigint       
AS        
BEGIN        
SELECT distinct cbd.Batch_Id      
,Batch_Code    
FROM Tbl_Course_Duration_Mapping cdm         
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id        
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id         
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id 
inner join  Tbl_Course_Department CD on   cdm.Course_Department_Id=CD.Course_Department_Id    
WHERE CD.Department_Id=@Department_Id
order by  Batch_Code    
END
    
    ')
END
GO
