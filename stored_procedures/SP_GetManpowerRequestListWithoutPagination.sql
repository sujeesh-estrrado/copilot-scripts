IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetManpowerRequestListWithoutPagination]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetManpowerRequestListWithoutPagination]
(
    @Searchkey VARCHAR(50) = ''''
)
AS
BEGIN
    SELECT
        M.ID,
        M.[Document_No],
        M.[Create_date],
        M.[Position_Id],
        M.[Prepared_By],
        E.[Employee_Id],
        M.[Department_Id],
        M.[Date_Of_Submission],
        ISNULL(E.[Employee_FName] + '' '' + E.[Employee_LName], '''') AS EmployeeName,
        M.[Revision_no],
        D.[Department_Name]
    FROM
        [dbo].[Tbl_Manpower_Request_Details] M
        LEFT JOIN dbo.Tbl_User U ON U.[user_Id] = M.[Prepared_By]
        LEFT JOIN Tbl_Employee_User EU ON EU.[User_Id] = U.[user_Id]
        LEFT JOIN [dbo].[Tbl_Employee] E ON E.[Employee_Id] = EU.Employee_Id
        LEFT JOIN [dbo].[Tbl_Department] D ON D.Department_Id = M.[Department_Id]
    WHERE
        M.[DelStatus] = 0
        AND (
            (M.[Document_No] LIKE ''%'' + @Searchkey + ''%'')
            OR (E.[Employee_FName] LIKE ''%'' + @Searchkey + ''%'')
            OR (CONCAT(E.Employee_FName, '' '', E.Employee_LName) LIKE ''%'' + @Searchkey + ''%'')
            OR @Searchkey = ''''
        )
    ORDER BY M.[Create_date] DESC
END
');
END;