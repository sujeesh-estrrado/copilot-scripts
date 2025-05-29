IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllEmployeesByDepartment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[SP_GetAllEmployeesByDepartment]       
@Course_Department_Id bigint   ,
@DurationMappingID  bigint
AS      
BEGIN      
 
SELECT  distinct   
E.Employee_Id,      
Employee_FName  As EmpName      
--ISNULL(Hours_per_week,'''') As Hours_per_week      
From Tbl_Employee E            
INNER JOIN Tbl_Emp_Intake_Program_Course_Mapping  EIP ON E.Employee_Id=EIP.Employee_Id
--LEFT  JOIN Tbl_Employee_Working_Hours            W   On E.Employee_Id=W.Employee_Id 
INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON  EIP.Batch_Id=CDP.Duration_Period_Id

Where EIP.Course_Department_Id=@Course_Department_Id and CDP.Duration_Period_Id=@DurationMappingID and E.Employee_Status =0
AND (EIP.Del_Status = 0 OR EIP.Del_Status IS NULL)
order by EmpName  


END


    ')
END
