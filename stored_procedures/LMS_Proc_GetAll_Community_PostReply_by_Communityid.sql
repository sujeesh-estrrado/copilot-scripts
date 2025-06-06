IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_GetAll_Community_PostReply_by_Communityid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_GetAll_Community_PostReply_by_Communityid]
    
@Community_Post_Id bigint    
AS    
    
BEGIN    
    
SELECT LMS_Tbl_Community_Post_Reply.Community_Post_Id,        
       Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName AS EmployeeName,    
       LMS_Tbl_Community_Post_Reply.Post_Reply,
       LMS_Tbl_Community_Post_Reply.Date 
        
    
 FROM  LMS_Tbl_Community_Post_Reply   
 INNER JOIN Tbl_Employee ON LMS_Tbl_Community_Post_Reply.Emp_Id=Tbl_Employee.Employee_Id    
 INNER JOIN LMS_Tbl_Community_Post  ON LMS_Tbl_Community_Post.Community_Post_Id =LMS_Tbl_Community_Post_Reply.Community_Post_Id

    
Where LMS_Tbl_Community_Post_Reply.Community_Post_Id=@Community_Post_Id   
    
END
    ')
END
