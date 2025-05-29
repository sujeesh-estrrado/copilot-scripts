IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Program_By_Employee]')
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[Sp_Get_Program_By_Employee]  
(
@EmployeeId BIGINT 
)              
              
AS              
              
BEGIN   
      
	  SELECT  DISTINCT
	  D.Department_Id, CONCAT(D.Department_Name,''-'',D.Course_Code)as Department_Name
	  FROM Tbl_Department D
	  INNER JOIN Tbl_Emp_Intake_Program_Course_Mapping E on D.Department_Id=E.Course_Department_Id
	  where E.Employee_Id=@EmployeeId

  
END  
    ')
END
GO
