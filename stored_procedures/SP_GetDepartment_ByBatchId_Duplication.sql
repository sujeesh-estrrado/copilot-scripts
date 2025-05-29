IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetDepartment_ByBatchId_Duplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetDepartment_ByBatchId_Duplication] 
(@Batch_Id BIGINT,
@CategoryId BIGINT)
    
AS      
BEGIN      
      
select       
CBD.Batch_Id,      
CBD.Duration_Id ,      
CBD.Batch_Code,      
CD.Course_Category_Id ,      
CC.Course_Category_Name ,      
CDep.Department_Id,CDep.Course_Department_Id,      
D.Department_Id as DepartmentId,      
D.Department_Name as DepartmentName      
      
from Tbl_Course_Batch_Duration CBD      
inner join Tbl_Course_Duration CD On CBD.Duration_Id=CD.Duration_Id      
inner join Tbl_Course_Category CC On CD.Course_Category_Id=CC.Course_Category_Id      
inner join Tbl_Course_Department CDep On CDep.Course_Category_Id=CD.Course_Category_Id      
inner join Tbl_Department D On D.Department_Id=CDep.Department_Id      
where CBD.Batch_Id=@Batch_Id  and  CD.Course_Category_Id=@CategoryId
order by DepartmentName  
END');
END;
