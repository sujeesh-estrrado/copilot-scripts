IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Bind_interview]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Bind_interview]
        (
            @PageSize BIGINT,
            @CurrentPage BIGINT,
            @SearchKeyWord VARCHAR(MAX)
        )
        AS
        BEGIN
            DECLARE @UpperBand BIGINT
            DECLARE @LowerBand BIGINT
            
            SET @UpperBand = (@PageSize * @CurrentPage) + 1
            SET @LowerBand = (@PageSize * (@CurrentPage - 1))

            SELECT * 
            FROM (
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
                FROM 
                    dbo.Tbl_Candidate_Personal_Det
                INNER JOIN 
                    dbo.Tbl_Interview_Schedule_Log ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Interview_Schedule_Log.candidate_id
                INNER JOIN 
                    dbo.Tbl_Employee ON dbo.Tbl_Interview_Schedule_Log.Staff_id = dbo.Tbl_Employee.Employee_Id
                INNER JOIN 
                    dbo.Tbl_Candidate_ContactDetails ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                WHERE 
                    (
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
    ')
END
