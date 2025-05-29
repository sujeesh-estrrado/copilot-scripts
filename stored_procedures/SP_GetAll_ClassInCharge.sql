IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_ClassInCharge]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_ClassInCharge]        
        
AS        
BEGIN        
SELECT         
CI.Class_InCharge_Id as ID,        
CI.Duration_Mapping_Id,        
CI.Employee_Id,        
E.Employee_FName+'' ''+E.Employee_LName as EmployeeName,        
E.Employee_Mobile,        
DP.Batch_Id,        
DP.Semester_Id,        
BD.Batch_Code,        
CS.Semester_Code,        
CS.Semester_Name,    
CC.Course_Category_Name as DepartmentName,      
D.Department_Name As ClassName         
        
FROM Tbl_Class_InCharge CI        
INNER JOIN Tbl_Employee E On E.Employee_Id=CI.Employee_Id        
INNER JOIN Tbl_Course_Duration_Mapping CDM On CDM.Duration_Mapping_Id=CI.Duration_Mapping_Id        
INNER JOIN Tbl_Course_Duration_PeriodDetails DP On DP.Duration_Period_Id=CDM.Duration_Period_Id         
INNER JOIN Tbl_Course_Semester CS On CS.Semester_Id=DP.Semester_Id        
INNER JOIN Tbl_Course_Batch_Duration BD On BD.Batch_Id=DP.Batch_Id        
Inner Join Tbl_Course_Department CD On CD.Course_Department_Id=CDM.Course_Department_Id     
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id      
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id       
       
        
WHERE CI.Class_InCharge_Status=0 and CDM.Course_Department_Status=0 and E.Employee_Status = 0       
        
END

');
END;