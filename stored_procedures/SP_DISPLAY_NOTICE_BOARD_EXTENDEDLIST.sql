IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_NOTICE_BOARD_EXTENDEDLIST]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DISPLAY_NOTICE_BOARD_EXTENDEDLIST]
(
    @Notice_Id BIGINT = NULL,  
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL,
    @flag INT = 0  -- Determines which dataset to return
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT;

    -- Pagination logic
    IF @PageSize IS NOT NULL AND @Currentpage IS NOT NULL AND @PageSize > 0 AND @Currentpage > 0
    BEGIN
        SET @Offset = @PageSize * (@Currentpage - 1);
    END
    ELSE
    BEGIN
        SET @Offset = 0;
    END

    -- Flag = 0: Fetch subject, announcement, and notice document
    IF @flag = 0
    BEGIN
        ;WITH NoticeDetails AS
        (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY n.Notice_Id DESC) AS SlNo,
                n.Createdate,
                n.Subject,
                n.Annoncement,
                n.Notice_Id,
                n.Notice_Doc
            FROM tbl_Notice_Board n
            WHERE 
                (@Notice_Id IS NULL OR n.Notice_Id = @Notice_Id)  
                AND (@fromdate IS NULL OR CONVERT(DATE, n.Createdate) >= @fromdate)
                AND (@todate IS NULL OR CONVERT(DATE, n.Createdate) < DATEADD(DAY, 1, @todate))
        )
        SELECT SlNo, Createdate, Subject, Annoncement, Notice_Id, Notice_Doc 
        FROM NoticeDetails
        WHERE 
            @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
            OR (SlNo > @Offset AND SlNo <= (@Offset + @PageSize));
    END
    -- Flag = 1: Fetch notice ID and link ID from Notice_Link_Maping
    ELSE IF @flag = 1
    BEGIN
        ;WITH NoticeDetails AS
        (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY n.Notice_Id DESC) AS SlNo,
                n.Notice_Id,
                el.Link_Id
            FROM tbl_Notice_Board n
            LEFT JOIN Notice_Link_Maping el ON n.Notice_Id = el.Notice_Id  
            WHERE 
                (@Notice_Id IS NULL OR n.Notice_Id = @Notice_Id)  
                AND (@fromdate IS NULL OR CONVERT(DATE, n.Createdate) >= @fromdate)
                AND (@todate IS NULL OR CONVERT(DATE, n.Createdate) < DATEADD(DAY, 1, @todate))
        )
        SELECT SlNo, Notice_Id, Link_Id 
        FROM NoticeDetails
        WHERE 
            @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
            OR (SlNo > @Offset AND SlNo <= (@Offset + @PageSize));
    END

    SET NOCOUNT OFF;
END;
    ')
END
