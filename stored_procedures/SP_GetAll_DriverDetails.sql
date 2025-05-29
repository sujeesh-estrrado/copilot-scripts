IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_DriverDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_DriverDetails]  
 
  
as  
Begin  
  
SELECT D.*,E.Employee_FName+'' ''+Employee_LName as Employeename FROM [Tbl_DriverDetails] D  
INNER JOIN Tbl_Employee E on E.Employee_Id=D.Employee_Id
WHERE DeleteStatus=0  
End

');
END;