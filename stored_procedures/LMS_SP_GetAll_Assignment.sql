IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Assignment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_GetAll_Assignment]

@Assignment_Id BIGINT
AS

 BEGIN

 SELECT LMS_Tbl_Assignment.Assignment_Id,
        LMS_Tbl_Assignment.Assignment_Title,
        LMS_Tbl_Assignment.Assignment_Desc,
        Tbl_Employee.Employee_FName AS EmployeeName,
        LMS_Tbl_Assignment.Due_Date,
        LMS_Tbl_Assignment.Assignment_Date,
        LMS_Tbl_Assignment.Status
    
 FROM  LMS_Tbl_Assignment
 INNER JOIN Tbl_Employee
 ON LMS_Tbl_Assignment.Emp_Id=Tbl_Employee.Employee_Id
 Where LMS_Tbl_Assignment.Assignment_Id=@Assignment_Id
 END
    ')
END
