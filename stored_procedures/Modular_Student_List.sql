IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Modular_Student_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Modular_Student_List]
    @courseid VARCHAR(MAX) = NULL,
    @flag BIGINT = 0,
    @scheduleid INT = 0,
    @passport NVARCHAR(100) = NULL,
    @country INT = NULL,
    @batchCode INT = NULL,
    @department INT = NULL,
    @status NVARCHAR(50) = NULL,
    @fromDate DATE = NULL,
    @toDate DATE = NULL,
    @searchkeyword VARCHAR(500) = NULL,
    @studentType VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH DateRange AS (
        SELECT 
            ScheduleId,
            MIN(Date) AS MinDate,
            MAX(Date) AS MaxDate
        FROM Tbl_Schedule_DayWise_Selection
        WHERE Isdeleted = 0
        GROUP BY ScheduleId
    )

    SELECT 
        ROW_NUMBER() OVER (ORDER BY md.Create_Date DESC) AS SINO,
        md.Modular_Candidate_Id,
        CONCAT(md.Candidate_Fname, '' '', md.Candidate_Lname) AS Name,
        md.Ic_Passport AS Passport,
        mc.CourseName,
        mc.CourseCode,
        CASE 
            WHEN md.Candidate_Id != 0 THEN ''Existing''
            ELSE ''New''
        END AS StudentStatus,
        n.Nationality,
        IM.id,
        BD.Batch_Code,
        D.Department_Name,
        CONCAT(NC.Mobile_Code, ''-'', md.Contact) AS Phone,
        md.Status,
        md.Email,
        md.Create_Date,
        CASE 
            WHEN S.selectiontype = 1 THEN 
                CONCAT(
                    CONVERT(VARCHAR, S.TimeLine_FromDate, 103), 
                    '' - '', 
                    CONVERT(VARCHAR, S.TimeLine_EndDate, 103)
                )
            WHEN S.selectiontype = 0 THEN 
                CONCAT(
                    CONVERT(VARCHAR, DR.MinDate, 103), 
                    '' - '', 
                    CONVERT(VARCHAR, DR.MaxDate, 103)
                )
            ELSE NULL
        END AS CourseDate
    FROM 
        Tbl_Modular_Candidate_Details AS md
        INNER JOIN tbl_Modular_Courses AS MC ON md.Modular_Course_Id = MC.Id 
        LEFT JOIN Tbl_Nationality AS n ON md.Country = n.Nationality_Id
        LEFT JOIN tbl_Nationality_Code NC ON n.Nationality_Id = NC.Nationality_Id
        LEFT JOIN Tbl_Candidate_Personal_Det AS CP ON CP.Candidate_Id = md.Candidate_Id
        LEFT JOIN tbl_New_Admission AS A ON CP.New_Admission_Id = A.New_Admission_Id        
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = a.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        LEFT JOIN Tbl_Department AS D ON D.Department_Id = A.Department_Id
        LEFT JOIN Tbl_Schedule_Planning AS S ON md.Modular_Slot_Id = S.Id AND S.Isdeleted = 0
        LEFT JOIN DateRange DR ON S.Id = DR.ScheduleId
    WHERE 
        md.Delete_Status = 0 
        AND md.Application_Status = ''Active'' 
        AND md.ActivatedStatus = 1    
        AND (@passport IS NULL OR @passport = '''' OR md.Ic_Passport = @passport)
    AND (@country IS NULL OR @country = 0 OR md.Country = @country)
    AND (@courseid IS NULL OR md.Modular_Course_Id IN (SELECT value FROM dbo.SplitStringFunction(@courseid, '','')))
    AND (@scheduleid IS NULL OR @scheduleid = 0 OR md.Modular_Slot_Id = @scheduleid)
    AND (@batchCode IS NULL OR @batchCode = 0 OR IM.id = @batchCode)
    AND (@department IS NULL OR @department = 0 OR D.Department_Id = @department)
    AND (@fromDate IS NULL OR md.Create_Date >= @fromDate)
    AND (@toDate IS NULL OR md.Create_Date <= @toDate)
    AND (
        @searchkeyword IS NULL 
        OR md.Candidate_Fname LIKE ''%'' + @searchkeyword + ''%'' 
        OR md.Candidate_Lname LIKE ''%'' + @searchkeyword + ''%'' 
        OR md.Ic_Passport LIKE ''%'' + @searchkeyword + ''%''
    )
   AND (
    @StudentType IS NULL OR @StudentType = ''0'' 
    OR (@StudentType = ''2'' AND md.Candidate_Id = 0) 
    OR (@StudentType = ''1'' AND md.Candidate_Id != 0)
)
AND (
    @status IS NULL OR @status = ''0'' OR md.Status = @status
)

ORDER BY 
    md.ActivatedStatus DESC,         
    md.Create_Date DESC, 
    md.Modular_Candidate_Id DESC

END
   ')
END;
