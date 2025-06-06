IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_GetAll_Community_Post_by_Communityid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_GetAll_Community_Post_by_Communityid] 
    
@Community_Id bigint    
AS    
    
BEGIN    
    
SELECT LMS_Tbl_Community_Post.Community_Id,    
          
       Tbl_Employee.Employee_FName+'' ''+Tbl_Employee.Employee_LName AS EmployeeName,    
       LMS_Tbl_Community_Post.Post,LMS_Tbl_Community_Post.Date,    
       LMS_Tbl_Community.Community_Name ,  
       LMS_Tbl_Community_Post.Community_Post_Id 
        
    
 FROM  LMS_Tbl_Community_Post    
 INNER JOIN Tbl_Employee ON LMS_Tbl_Community_Post.Emp_Id=Tbl_Employee.Employee_Id    
 INNER JOIN LMS_Tbl_Community  ON LMS_Tbl_Community.Community_Id =LMS_Tbl_Community_Post.Community_Id

    
Where LMS_Tbl_Community_Post.Community_Id=@Community_Id    
    
END
    ')
END
