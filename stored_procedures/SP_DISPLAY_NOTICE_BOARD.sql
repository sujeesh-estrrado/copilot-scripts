IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_NOTICE_BOARD]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DISPLAY_NOTICE_BOARD]
(
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT;

    IF @PageSize IS NOT NULL AND @Currentpage IS NOT NULL AND @PageSize > 0 AND @Currentpage > 0
    BEGIN
        SET @Offset = @PageSize * (@Currentpage - 1);
    END
    ELSE
    BEGIN
        SET @Offset = 0;
    END

    ;WITH NoticeDetails AS
    (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY n.Notice_Id DESC) AS SlNo, -- Order by Notice_Id instead of Createdate
            n.Createdate,
            n.Subject,
            n.Notice_Id,
            e.Employee_Id, 
             CASE 
                WHEN e.Employee_Id = 1 THEN ''Admin'' 
                ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) 
            END AS EmployeeName -- Concatenate first and last name
        FROM 
            tbl_Notice_Board n
        LEFT JOIN 
            tbl_Employee e ON n.Notice_Created = e.Employee_Id -- Join on employee ID
        WHERE 
            (@fromdate IS NULL OR CONVERT(DATE, n.Createdate) >= @fromdate)
            AND (@todate IS NULL OR CONVERT(DATE, n.Createdate) < DATEADD(DAY, 1, @todate))
    )
    SELECT *
    FROM NoticeDetails
    WHERE 
        @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
        OR (
            SlNo > @Offset AND SlNo <= (@Offset + @PageSize)
        );

    SET NOCOUNT OFF;
END;
    ')
END
