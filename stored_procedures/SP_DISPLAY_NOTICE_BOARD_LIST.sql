IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_NOTICE_BOARD_LIST]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DISPLAY_NOTICE_BOARD_LIST]
(
    @CandidateId BIGINT = NULL,  -- Added CandidateId parameter
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables for Candidate''s Faculty, Program, and Intake
    DECLARE @FacultyId BIGINT, @ProgramId BIGINT, @IntakeId Varchar(50);
    DECLARE @Offset INT, @CandidateCreatedDate DATETIME;

    -- Fetch Candidate''s Faculty, Program, and Intake, and CandidateCreatedDate
    IF @CandidateId IS NOT NULL
    BEGIN
        SELECT 
            @FacultyId = n.Course_Level_Id,
            @ProgramId = n.Department_Id,
            @IntakeId = BD.Batch_Code,
            @CandidateCreatedDate = CPD.PromoteDate
        FROM dbo.Tbl_Candidate_Personal_Det AS CPD
        LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = n.Batch_Id 
        WHERE CPD.Candidate_Id = @CandidateId;
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
            n.Annoncement,
            n.Notice_Id,
            e.Employee_Id, 
            CASE 
                WHEN e.Employee_Id = 1 THEN ''Admin'' 
                ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) 
            END AS EmployeeName 
        FROM tbl_Notice_Board n
        LEFT JOIN tbl_Employee e ON n.Notice_Created = e.Employee_Id
        WHERE 
            (@fromdate IS NULL OR CONVERT(DATE, n.Createdate) >= @fromdate)
            AND (@todate IS NULL OR CONVERT(DATE, n.Createdate) < DATEADD(DAY, 1, @todate))
            AND (
                n.Select_All_Students = 1
                OR EXISTS (SELECT 1 FROM Notice_Student_Maping NSM WHERE NSM.Notice_Id = n.Notice_Id AND NSM.Student_Id = @CandidateId)
                OR TRY_CAST(n.selected_Students AS BIGINT) = @CandidateId
                OR (@FacultyId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Faculty_Maping WHERE Notice_Id = n.Notice_Id AND Faculty_Id = @FacultyId))
                OR (@ProgramId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Program_Maping WHERE Notice_Id = n.Notice_Id AND Program_Id = @ProgramId))
                OR (@IntakeId IS NOT NULL AND EXISTS (SELECT 1 FROM Notice_Intake_Maping WHERE Notice_Id = n.Notice_Id AND Intake_Id = @IntakeId))
            )
            AND (
                @CandidateCreatedDate IS NULL 
                OR CONVERT(DATE, n.Createdate) > CONVERT(DATE, @CandidateCreatedDate)
            )
    )
    
    -- Fetch paginated results
    SELECT * FROM NoticeDetails
    WHERE 
        @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
        OR (SlNo > @Offset AND SlNo <= (@Offset + @PageSize));

    SET NOCOUNT OFF;
END;
    ')
END
