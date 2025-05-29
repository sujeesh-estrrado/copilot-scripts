IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Report_recruitment_changelog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Report_recruitment_changelog]
(
    @flag BIGINT = 0,
    @fromdate DATETIME = NULL,
    @Todate DATETIME = NULL,
    @studentid BIGINT = 0,
    @staffid BIGINT = 0,
    @PageSize BIGINT = 10,
    @CurrentPage BIGINT = 1
)
AS
BEGIN
    IF (@Flag = 0) -- Get paginated results
    BEGIN
        SELECT  
            c.Candidate_Id,
            CONCAT(c.Candidate_Fname, '' '', c.Candidate_Lname) AS studentname,
            c.AdharNumber,
            c.IDmatrixNo,
            datelog,
            CONCAT(b.Employee_Fname, '' '', b.Employee_Lname) AS staffname,
            CASE 
                WHEN oldcounsellor = 0 THEN ''N/A'' 
                WHEN oldcounsellor IS NULL THEN ''N/A'' 
                ELSE CONCAT(E.Employee_Fname, '' '', E.Employee_Lname) 
            END AS OldCounsellorname,
            CASE 
                WHEN oldagent = 0 THEN ''N/A'' 
                WHEN oldagent IS NULL THEN ''N/A'' 
                ELSE AG.Agent_Name 
            END AS oldagentname,
            CASE 
                WHEN oldother = ''0'' THEN ''N/A'' 
                WHEN oldother = '''' THEN ''N/A'' 
                WHEN oldother IS NULL THEN ''N/A'' 
                ELSE oldother 
            END AS oldother,
            CASE 
                WHEN newcounsellor = 0 THEN ''N/A'' 
                WHEN newcounsellor IS NULL THEN ''N/A'' 
                ELSE CONCAT(NE.Employee_Fname, '' '', NE.Employee_Lname)
            END AS NewCounsellorname,
            CASE 
                WHEN newagent = 0 THEN ''N/A'' 
                WHEN newagent IS NULL THEN ''N/A'' 
                ELSE NAG.Agent_Name 
            END AS newagentname,
            CASE 
                WHEN newother = ''0'' THEN ''N/A''
                WHEN newother = '''' THEN ''N/A'' 
                WHEN newother IS NULL THEN ''N/A'' 
                ELSE newother 
            END AS newother
        FROM log_universal a
        LEFT JOIN Tbl_Employee b ON a.staffid = b.Employee_Id
        LEFT JOIN Tbl_Candidate_Personal_Det c ON a.studentid = c.Candidate_Id
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = oldcounsellor
        LEFT JOIN Tbl_Agent AG ON AG.Agent_Id = oldagent
        LEFT JOIN Tbl_Employee NE ON NE.Employee_Id = newcounsellor
        LEFT JOIN Tbl_Agent NAG ON NAG.Agent_Id = newagent
        WHERE a.description = ''Changing Marketing Recruited By Record''
          AND a.oldrecord != a.newrecord 
          AND a.studentid != 0 
          AND c.Candidate_Id IS NOT NULL 
          AND (@staffid = 0 OR staffid = @staffid) 
          AND (@studentid = 0 OR studentid = @studentid)
          AND (
                (CONVERT(DATE, datelog) >= @fromdate AND CONVERT(DATE, datelog) < DATEADD(day, 1, @Todate))
                OR (@fromdate IS NULL AND @Todate IS NULL)
                OR (@fromdate IS NULL AND CONVERT(DATE, datelog) < DATEADD(day, 1, @Todate))
                OR (@Todate IS NULL AND CONVERT(DATE, datelog) >= @fromdate)
              )
        ORDER BY c.Candidate_Fname 
        OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END
    
    IF (@Flag = 1) -- Get total count
    BEGIN
        SELECT COUNT(c.Candidate_Id) AS totcount
        FROM log_universal a
        LEFT JOIN Tbl_Employee b ON a.staffid = b.Employee_Id
        LEFT JOIN Tbl_Candidate_Personal_Det c ON a.studentid = c.Candidate_Id
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = oldcounsellor
        LEFT JOIN Tbl_Agent AG ON AG.Agent_Id = oldagent
        LEFT JOIN Tbl_Employee NE ON NE.Employee_Id = newcounsellor
        LEFT JOIN Tbl_Agent NAG ON NAG.Agent_Id = newagent
        WHERE a.description = ''Changing Marketing Recruited By Record''
          AND a.oldrecord != a.newrecord 
          AND a.studentid != 0 
          AND c.Candidate_Id IS NOT NULL 
          AND (@staffid = 0 OR staffid = @staffid) 
          AND (@studentid = 0 OR studentid = @studentid)
          AND (
                (CONVERT(DATE, datelog) >= @fromdate AND CONVERT(DATE, datelog) < DATEADD(day, 1, @Todate))
                OR (@fromdate IS NULL AND @Todate IS NULL)
                OR (@fromdate IS NULL AND CONVERT(DATE, datelog) < DATEADD(day, 1, @Todate))
                OR (@Todate IS NULL AND CONVERT(DATE, datelog) >= @fromdate)
              );
    END
END
');
END;