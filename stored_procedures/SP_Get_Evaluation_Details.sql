IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Evaluation_Details]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_Evaluation_Details]
    (
        @SearchKeyWord VARCHAR(MAX),
        @PageSize BIGINT,
        @CurrentPage BIGINT,
        @Position_id BIGINT,
        @Faculty_Id BIGINT,
        @flag BIGINT = 0
    )
    AS
    BEGIN
        IF (@flag = 0)
        BEGIN
            SELECT
                J.ID,
                J.[EvaluationID],
                C.Course_Level_Name,
                D.Dept_Designation_Name,
                (SELECT COUNT(*) 
                 FROM Tbl_HRMS_Interview_Schedule H 
                 WHERE H.[ID] = J.Schedule_ID
                ) AS No_Of_Participants,
                J.Interview_Type,
                SP.[Interview_Status],
                SC.Schedule_Number
            FROM 
                [dbo].[Tbl_HRMS_Interview_Evaluation] J
                LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] D ON D.Dept_Designation_Id = J.Job_Position
                LEFT JOIN Tbl_Course_Level C ON C.Course_Level_Id = J.Department_Id
                LEFT JOIN [dbo].[Tbl_HRMS_Primary_Interview_Details] SP ON SP.[Schedule_Id] = J.[ID]
                LEFT JOIN Tbl_HRMS_Interview_Schedule SC ON SC.ID = J.Schedule_ID
            WHERE
                J.[DelStatus] = 0
                AND (J.Job_Position = @Position_id OR @Position_id = 0)
                AND (J.Department_Id = @Faculty_Id OR @Faculty_Id = 0)
                AND (
                    J.[EvaluationID] LIKE ''%'' + @SearchKeyWord + ''%''
                    OR CONVERT(VARCHAR, J.[Evaluation_Creation_Date], 103) LIKE ''%'' + @SearchKeyWord + ''%''
                    OR C.Course_Level_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    OR D.Dept_Designation_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    OR SC.Schedule_Number LIKE ''%'' + @SearchKeyWord + ''%''
                    OR J.Interview_Type LIKE ''%'' + @SearchKeyWord + ''%''
                )
            ORDER BY 
                J.[ID] DESC
            OFFSET @PageSize * (@CurrentPage - 1) ROWS
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)
        END
        
        IF (@flag = 1)
        BEGIN
            SELECT
                COUNT(J.[EvaluationID]) AS count
            FROM
                [dbo].[Tbl_HRMS_Interview_Evaluation] J
                LEFT JOIN [dbo].[Tbl_Emp_DeptDesignation] D ON D.Dept_Designation_Id = J.Job_Position
                LEFT JOIN Tbl_Course_Level C ON C.Course_Level_Id = J.Department_Id
                LEFT JOIN [dbo].[Tbl_HRMS_Primary_Interview_Details] SP ON SP.[Schedule_Id] = J.[ID]
                LEFT JOIN Tbl_HRMS_Interview_Schedule SC ON SC.ID = J.Schedule_ID
            WHERE
                J.[DelStatus] = 0
                AND (J.Job_Position = @Position_id OR @Position_id = 0)
                AND (J.Department_Id = @Faculty_Id OR @Faculty_Id = 0)
                AND (
                    J.[EvaluationID] LIKE ''%'' + @SearchKeyWord + ''%''
                    OR CONVERT(VARCHAR, J.[Evaluation_Creation_Date], 103) LIKE ''%'' + @SearchKeyWord + ''%''
                    OR C.Course_Level_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    OR D.Dept_Designation_Name LIKE ''%'' + @SearchKeyWord + ''%''
                    OR SC.Schedule_Number LIKE ''%'' + @SearchKeyWord + ''%''
                    OR J.Interview_Type LIKE ''%'' + @SearchKeyWord + ''%''
                )
        END
    END
    ')
END
