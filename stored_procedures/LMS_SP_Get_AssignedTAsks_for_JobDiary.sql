IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_AssignedTAsks_for_JobDiary]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_AssignedTAsks_for_JobDiary] -- 446  
 -- Add the parameters for the stored procedure here    
 @Student_Id bigint 
AS    
BEGIN    
 select LAS.AssignTask_Id,LAS.Assigned_Date,LAS.Task_Name,LAS.Estimated_Time,LAS.Target_Date,LAS.Description,    
case LAS.Status when 0 then ''Not Completed'' else ''Completed'' end as Status,E.Employee_FName+'' ''+E.Employee_LName as Emp_Name from LMS_Tbl_AssignTaskToStudents  LAS  
inner join Tbl_Employee E on LAS.User_Id=E.Employee_Id
 where E.Employee_Status=0 and LAS.Status=0 and LAS.Student_Id=@Student_Id 
END
    ')
END
