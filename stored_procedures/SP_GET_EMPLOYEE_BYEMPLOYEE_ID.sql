IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EMPLOYEE_BYEMPLOYEE_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GET_EMPLOYEE_BYEMPLOYEE_ID]      
 @Employee_Id bigint      
AS      
BEGIN      
SELECT Employee_FName+'' ''+Employee_LName as EmployeeName      
FROM dbo.Tbl_Employee      
WHERE Employee_Id= @Employee_Id      
END
'

);
END;
