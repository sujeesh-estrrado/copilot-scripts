IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Active_student_no]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[SP_Active_student_no]
  @fromdate DATETIME = NULL,
  @todate DATETIME = NULL,
  @CurrentPage INT = NULL,
  @PageSize INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Default pagination parameters
    IF @PageSize IS NULL OR @CurrentPage IS NULL OR @PageSize <= 0 OR @CurrentPage <= 0
    BEGIN
        -- Query without pagination
        SELECT
            D.Department_Name AS Programme,
            COUNT(CASE 
                     WHEN CPD.ApplicationStatus = ''Completed'' 
                     AND (
                         (CPD.PromoteDate >= @fromdate AND CPD.PromoteDate < DATEADD(DAY, 1, @todate)) 
                         OR (@fromdate IS NULL AND @todate IS NULL)
                         OR (@fromdate IS NULL AND CPD.PromoteDate < DATEADD(DAY, 1, @todate))
                         OR (@todate IS NULL AND CPD.PromoteDate >= @fromdate)
                     )
                 THEN CPD.New_Admission_Id
                 END) AS StudentNo
        FROM
            Tbl_Department AS D
        LEFT JOIN
            tbl_New_Admission AS NA ON D.Department_Id = NA.Department_Id
        LEFT JOIN
            dbo.Tbl_Candidate_Personal_Det AS CPD ON CPD.New_Admission_Id = NA.New_Admission_Id
        GROUP BY
            D.Department_Name;
    END
    ELSE
    BEGIN
        -- Query with pagination
        DECLARE @Offset INT;
        SET @Offset = @PageSize * (@CurrentPage - 1);

        SELECT
            D.Department_Name AS Programme,
            COUNT(CASE 
                     WHEN CPD.ApplicationStatus = ''Completed'' 
                     AND (
                         (CPD.PromoteDate >= @fromdate AND CPD.PromoteDate < DATEADD(DAY, 1, @todate)) 
                         OR (@fromdate IS NULL AND @todate IS NULL)
                         OR (@fromdate IS NULL AND CPD.PromoteDate < DATEADD(DAY, 1, @todate))
                         OR (@todate IS NULL AND CPD.PromoteDate >= @fromdate)
                     )
                 THEN CPD.New_Admission_Id
                 END) AS StudentNo
        FROM
            Tbl_Department AS D
        LEFT JOIN
            tbl_New_Admission AS NA ON D.Department_Id = NA.Department_Id
        LEFT JOIN
            dbo.Tbl_Candidate_Personal_Det AS CPD ON CPD.New_Admission_Id = NA.New_Admission_Id
        GROUP BY
            D.Department_Name
        ORDER BY
            D.Department_Name
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END

    SET NOCOUNT OFF;
END;
    ');
END
