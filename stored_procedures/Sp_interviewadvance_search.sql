IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_interviewadvance_search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_interviewadvance_search]
(
    @PageSize BIGINT,
    @CurrentPage BIGINT,
    @SearchKeyWord VARCHAR(MAX) = '''',  
    @result VARCHAR(100) = ''--Select--''
)
AS 
BEGIN
    DECLARE @UpperBand BIGINT
    DECLARE @LowerBand BIGINT
    DECLARE @res VARCHAR(200)
    
    SET @UpperBand = (@PageSize * @CurrentPage) + 1
    SET @LowerBand = (@PageSize * (@CurrentPage - 1))
    SET @res = @result
    
    IF (@res != ''--Select--'')
    BEGIN
        SELECT * FROM (
            SELECT  
                ROW_NUMBER() OVER(ORDER BY dbo.Tbl_Candidate_Personal_Det.Candidate_Id DESC) AS RowNumber,
                dbo.Tbl_Candidate_Personal_Det.Candidate_Fname + '' '' + dbo.Tbl_Candidate_Personal_Det.Candidate_Lname AS CandidateName, 
                dbo.Tbl_Candidate_Personal_Det.AdharNumber, 
                dbo.Tbl_Candidate_Personal_Det.ApplicationStatus,
                CONVERT(VARCHAR, dbo.Tbl_Interview_Schedule_Log.Interview_date, 103) AS Interview_date, 
                CONVERT(VARCHAR, dbo.Tbl_Interview_Schedule_Log.reschedule_date, 103) AS reschedule_date,
                dbo.Tbl_Interview_Schedule_Log.Interview_status, 
                dbo.Tbl_Interview_Schedule_Log.candidate_id AS ID, 
                dbo.Tbl_Interview_Schedule_Log.Staff_id, 
                dbo.Tbl_Employee.Employee_FName, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID
            FROM dbo.Tbl_Candidate_Personal_Det 
            INNER JOIN dbo.Tbl_Interview_Schedule_Log 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id 
            LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id 
            LEFT OUTER JOIN dbo.Tbl_Employee_User 
                INNER JOIN dbo.Tbl_Employee 
                    ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id 
                ON dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
            WHERE dbo.Tbl_Interview_Schedule_Log.Interview_status = @res  
            AND (
                dbo.Tbl_Candidate_Personal_Det.Candidate_Id LIKE ''%'' + @SearchKeyWord + ''%''
                OR Tbl_Candidate_Personal_Det.Candidate_Fname LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Candidate_Personal_Det.AdharNumber LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Interview_Schedule_Log.Interview_status LIKE ''%'' + @SearchKeyWord + ''%''  
                OR Interview_date LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Candidate_ContactDetails.Candidate_Email LIKE ''%'' + @SearchKeyWord + ''%''
            )
        ) AS tab 
        WHERE RowNumber > @LowerBand AND RowNumber < @UpperBand 
    END
    ELSE
    BEGIN
        SELECT * FROM (
            SELECT  
                ROW_NUMBER() OVER(ORDER BY dbo.Tbl_Candidate_Personal_Det.Candidate_Id DESC) AS RowNumber,
                dbo.Tbl_Candidate_Personal_Det.Candidate_Fname + '' '' + dbo.Tbl_Candidate_Personal_Det.Candidate_Lname AS CandidateName, 
                dbo.Tbl_Candidate_Personal_Det.AdharNumber, 
                dbo.Tbl_Candidate_Personal_Det.ApplicationStatus,
                CONVERT(VARCHAR, dbo.Tbl_Interview_Schedule_Log.Interview_date, 103) AS Interview_date, 
                CONVERT(VARCHAR, dbo.Tbl_Interview_Schedule_Log.reschedule_date, 103) AS reschedule_date,
                dbo.Tbl_Interview_Schedule_Log.Interview_status, 
                dbo.Tbl_Interview_Schedule_Log.candidate_id AS ID, 
                dbo.Tbl_Interview_Schedule_Log.Staff_id, 
                dbo.Tbl_Employee.Employee_FName, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID
            FROM dbo.Tbl_Candidate_Personal_Det 
            INNER JOIN dbo.Tbl_Interview_Schedule_Log 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id 
            LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id 
            LEFT OUTER JOIN dbo.Tbl_Employee_User 
                INNER JOIN dbo.Tbl_Employee 
                    ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id 
                ON dbo.Tbl_Interview_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
            WHERE (
                dbo.Tbl_Candidate_Personal_Det.Candidate_Id LIKE ''%'' + @SearchKeyWord + ''%''
                OR Tbl_Candidate_Personal_Det.Candidate_Fname LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Candidate_Personal_Det.AdharNumber LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Interview_Schedule_Log.Interview_status LIKE ''%'' + @SearchKeyWord + ''%''  
                OR Interview_date LIKE ''%'' + @SearchKeyWord + ''%'' 
                OR Tbl_Candidate_ContactDetails.Candidate_Email LIKE ''%'' + @SearchKeyWord + ''%''
            )
        ) AS tab 
        WHERE RowNumber > @LowerBand AND RowNumber < @UpperBand 
    END
END
');
END;