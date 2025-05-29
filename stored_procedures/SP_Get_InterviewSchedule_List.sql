IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_InterviewSchedule_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE PROCEDURE [dbo].[SP_Get_InterviewSchedule_List] --'''',10,1    
@SearchKeyWord varchar(max),    
@PageSize bigint,    
@CurrentPage bigint    
    
AS    
BEGIN    
 SELECT DISTINCT S.[ID] as Schedule_Id,S.[Schedule_Number] as Schedule_No,convert(varchar(50),S.[Schedule_Creation_Date],103 ) as [Schedule_Creation_Date]    
 ,S.[Department_Id],S.[Job_Position],D.Course_Level_Name AS Department_Name,P.[Dept_Designation_Name] AS role_Name    
 ,(select COUNT([Schedule_Id]) from  [dbo].[Tbl_HRMS_Primary_Interview_Details] where [Schedule_Id]=S.ID ) as No_of_Participants    
 --,SP.[Start_Time] as [Start_Date],SP.[End_Time] as [End_Date]    
 ,SP.[Interview_Type],SP.[Interview_Status]    
 FROM [dbo].[Tbl_HRMS_Interview_Schedule] S    
  LEFT JOIN [Tbl_Course_Level] D ON D.Course_Level_Id=S.Department_Id    
  LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] P ON P.Dept_Designation_Id=S.[Job_Position]    
  LEFT JOIN [dbo].[Tbl_HRMS_Primary_Interview_Details] SP ON SP.[Schedule_Id]=S.[ID]    
 WHERE S.[Del_Status]=0 AND    
 (S.[Schedule_Number] like ''%''+@SearchKeyWord +''%'' or S.[Schedule_Creation_Date] like ''%''+@SearchKeyWord +''%'' or D.Course_Level_Name like ''%''+@SearchKeyWord +''%''    
 or P.[Dept_Designation_Name] like ''%''+@SearchKeyWord +''%'' or SP.[Start_Time] like ''%''+@SearchKeyWord +''%'' or SP.[End_Time] like ''%''+@SearchKeyWord +''%'' or SP.Interview_Type like ''%''+@SearchKeyWord +''%''    
 or SP.Interview_Status like ''%''+@SearchKeyWord +''%'')    
 ORDER BY S.ID DESC  
 OFFSET @PageSize * (@CurrentPage - 1) ROWS          
 FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);       
END 
    ')
END
