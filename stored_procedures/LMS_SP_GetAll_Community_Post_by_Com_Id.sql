IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Community_Post_by_Com_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_GetAll_Community_Post_by_Com_Id]
  
@Community_Id bigint  
AS  
  
BEGIN  
  
SELECT LMS_Tbl_Community_Post.Community_Id,
       Tbl_Employee.Employee_FName AS EmployeeName,
       LMS_Tbl_Community_Post.Post,LMS_Tbl_Community_Post.Date
 FROM  LMS_Tbl_Community_Post
 INNER JOIN Tbl_Employee
ON LMS_Tbl_Community_Post.Emp_Id=Tbl_Employee.Employee_Id
Where LMS_Tbl_Community_Post.Community_Id=@Community_Id
 END
    ')
END
