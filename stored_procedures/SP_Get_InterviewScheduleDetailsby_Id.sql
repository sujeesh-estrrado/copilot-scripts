IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_InterviewScheduleDetailsby_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_InterviewScheduleDetailsby_Id] --1  
@Evaluation_Id bigint  
AS  
BEGIN  
 select E.[EvaluationID],convert(varchar(100),E.[Evaluation_Creation_Date],103) as [Evaluation_Creation_Date],E.[Schedule_ID],E.[Department_Id],E.[Job_Position]  
 ,S.[Schedule_Number],C.Course_Level_Name,J.Dept_Designation_Name  
 from [dbo].[Tbl_HRMS_Interview_Evaluation] E  
 left join [dbo].[Tbl_HRMS_Interview_Schedule] S on S.ID=E.Schedule_ID  
 left join [dbo].[Tbl_Course_Level] C on C.Course_Level_Id=E.Department_Id  
 left join [dbo].[Tbl_Emp_DeptDesignation] J on J.Dept_Designation_Id=E.Job_Position  
 where E.[ID]=@Evaluation_Id  
  
END

    ')
END
