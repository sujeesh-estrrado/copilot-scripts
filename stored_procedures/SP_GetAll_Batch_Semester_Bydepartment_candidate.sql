IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Mapping_By_CourseDepartmentId]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Batch_Mapping_By_CourseDepartmentId]         
@Course_Department_Id bigint         
AS          
BEGIN          
SELECT           
       
distinct cdp.Batch_Id as BatchID,Batch_Code as BatchName      
      
FROM Tbl_Course_Duration_Mapping cdm           
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id           
INNER JOIN dbo.Tbl_Course_Department CD ON CD.Department_Id=CDM.Course_Department_Id  
INNER JOIN  Tbl_Department D ON D.Department_Id = CD.Department_Id        
WHERE CD.Department_Id =@Course_Department_Id and cbd.Batch_DelStatus=0      
order by BatchName    
END  
    ')
END
GO
