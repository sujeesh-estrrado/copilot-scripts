IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_NOTICE_BOARD_LISTEMP]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DISPLAY_NOTICE_BOARD_LISTEMP]
(
    @EmployeeId BIGINT = NULL,  
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DepId BIGINT, @RoleId BIGINT, @EmployeeCreatedDate DATETIME;
    DECLARE @Offset INT;

    IF @EmployeeId IS NOT NULL
    BEGIN
        SELECT 
            @DepId = eo.Department_Id,
            @RoleId = ra.Role_Id,
            @EmployeeCreatedDate = eo.Created_Date  -- Get the Employee Created Date
        FROM dbo.Tbl_Employee AS e
        LEFT JOIN dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id
        LEFT JOIN dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
        LEFT JOIN dbo.Tbl_RoleAssignment AS ra ON e.Employee_Id = ra.Employee_Id
        LEFT JOIN dbo.Tbl_Employee_User AS eu ON e.Employee_Id = eu.Employee_Id
    WHERE eu.User_Id = @employeeId;
    END

    -- Pagination logic
    IF @PageSize IS NOT NULL AND @Currentpage IS NOT NULL AND @PageSize > 0 AND @Currentpage > 0
    BEGIN
        SET @Offset = @PageSize * (@Currentpage - 1);
    END
    ELSE
    BEGIN
        SET @Offset = 0;
    END

    -- CTE to get the relevant notices
    ;WITH NoticeDetails AS
    (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY n.Notice_Id DESC) AS SlNo,
            n.Createdate,
            n.Subject,
            n.Notice_Id,
            e.Employee_Id, 
            CASE 
                WHEN e.Employee_Id = 1 THEN ''Admin'' 
                ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) 
            END AS EmployeeName 
        FROM tbl_Notice_Board n
        LEFT JOIN tbl_Employee e ON n.Notice_Created = e.Employee_Id
        WHERE 
            (@EmployeeCreatedDate IS NULL OR CONVERT(DATE, n.Createdate) > CONVERT(DATE, @EmployeeCreatedDate))
            AND (
                n.Select_All_Employee = 1  
                OR EXISTS (SELECT 1 FROM Notice_Employee_Maping WHERE Notice_Id = n.Notice_Id AND Employee_Id = @EmployeeId)
                OR EXISTS (SELECT 1 FROM Notice_Department_Maping WHERE Notice_Id = n.Notice_Id AND (Department_Id = @DepId OR @DepId IS NULL))
                OR EXISTS (SELECT 1 FROM Notice_Role_Maping WHERE Notice_Id = n.Notice_Id AND (Role_Id = @RoleId OR @RoleId IS NULL))
            )
    )

    SELECT * FROM NoticeDetails
    WHERE 
        @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
        OR (SlNo > @Offset AND SlNo <= (@Offset + @PageSize));

    SET NOCOUNT OFF;
END;
    ')
END
