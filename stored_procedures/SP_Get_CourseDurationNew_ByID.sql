IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseDurationNew_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CourseDurationNew_ByID] --1
(@Duration_Id bigint)    
AS    
BEGIN    
    
SELECT Duration_Id as ID,Program_Org_Id as Org_Id,Program_Category_Id as CourseCatID,Program_Duration_Type as DurationType,Tbl_Department.Department_Name,    
Program_Duration_Year,Program_Duration_Sem,Program_Duration_Month,Program_Duration_Days,Tbl_Department.Course_Code    
    
    
FROM  dbo.Tbl_Program_Duration 
left join  dbo.Tbl_Department on Tbl_Department.Department_Id=Tbl_Program_Duration.Program_Category_Id  
    
WHERE Duration_Id=@Duration_Id and Program_Duration_DelStatus=0    
    
    
END
    ');
END;
