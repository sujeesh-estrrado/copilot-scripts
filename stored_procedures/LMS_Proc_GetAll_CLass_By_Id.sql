IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_GetAll_CLass_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_GetAll_CLass_By_Id](@Class_Id bigint)

AS

BEGIN

SELECT




 EC.Emp_Class_Id,
 C.Class_Id,
 EC.Emp_Id,
 C.Class_Name,
 E.Employee_FName+''''+Employee_LName as [Employee]

       
FROM    dbo.LMS_Tbl_Class C 
 INNER JOIN dbo.LMS_Tbl_Emp_Class EC on C.Class_Id=EC.Class_Id
 INNER JOIN dbo.Tbl_Employee E on E.Employee_Id=EC.Emp_Id

where C.Class_Id=   @Class_Id   
END
    ')
END
