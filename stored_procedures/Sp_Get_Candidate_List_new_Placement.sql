IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Candidate_List_new_Placement]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Candidate_List_new_Placement]
    (
        @SearchKeyWord varchar(max),
        @CurrentPage int = null,
        @pagesize bigint = null,
        @organization_id bigint = 0, 
        @intake_id bigint = 0,
        @Department_id bigint = 0,
        @Flag bigint = 0 
    )
    AS 
    BEGIN
        IF (@Flag = 0)
        BEGIN
            SELECT 
                CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) AS CandidateName, 
                dbo.Tbl_Candidate_Personal_Det.AdharNumber,
                CONVERT(varchar, dbo.Tbl_Placement_Schedule_Log.Placement_date, 103) AS Placement_date, 
                CONVERT(varchar, dbo.Tbl_Placement_Schedule_Log.reschedule_date, 103) AS reschedule_date,
                dbo.Tbl_Placement_Schedule_Log.Placement_status, 
                dbo.Tbl_Placement_Schedule_Log.candidate_id AS ID, 
                dbo.Tbl_Placement_Schedule_Log.Staff_id, 
                dbo.Tbl_Employee.Employee_FName, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber, 
                dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID,
                dbo.Tbl_Candidate_Personal_Det.ApplicationStatus AS ApplicationStatus
            FROM dbo.Tbl_Candidate_Personal_Det 
            INNER JOIN dbo.Tbl_Placement_Schedule_Log 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Placement_Schedule_Log.candidate_id 
            LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id 
            LEFT OUTER JOIN dbo.Tbl_Employee_User 
                LEFT JOIN dbo.Tbl_Employee 
                    ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id 
                ON dbo.Tbl_Placement_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
            LEFT JOIN tbl_New_Admission NA 
                ON NA.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.New_Admission_Id
            WHERE ((Placement_status = '''' OR Placement_status IS NULL OR Placement_status = ''Fail'' OR Placement_status = ''AB'') 
                  AND dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus = 0  
                  AND (dbo.Tbl_Candidate_Personal_Det.Campus = @organization_id OR @organization_id = 0)
                  AND (NA.Department_Id = @Department_id OR @Department_id = 0)
                  AND (NA.Batch_Id = @intake_id OR @intake_id = 0))
                  AND (dbo.Tbl_Candidate_Personal_Det.Candidate_Id LIKE ''%'' + @SearchKeyWord + ''%''
                      OR CONCAT(Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', Tbl_Candidate_Personal_Det.Candidate_Lname) LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR Tbl_Candidate_Personal_Det.AdharNumber LIKE ''%'' + @SearchKeyWord + ''%''
                      OR Placement_date LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR Tbl_Candidate_ContactDetails.Candidate_Email LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR @SearchKeyWord = '''')            
            ORDER BY ID DESC   
            OFFSET @pagesize * (@CurrentPage - 1) ROWS
            FETCH NEXT @pagesize ROWS ONLY
        END
        
        IF (@Flag = 1)
        BEGIN
            SELECT COUNT(*) AS counts 
            FROM dbo.Tbl_Candidate_Personal_Det
            INNER JOIN dbo.Tbl_Placement_Schedule_Log 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Placement_Schedule_Log.candidate_id 
            LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id 
            LEFT OUTER JOIN dbo.Tbl_Employee_User 
                LEFT JOIN dbo.Tbl_Employee 
                    ON dbo.Tbl_Employee_User.Employee_Id = dbo.Tbl_Employee.Employee_Id 
                ON dbo.Tbl_Placement_Schedule_Log.Scheduled_by = dbo.Tbl_Employee_User.Employee_Id
            LEFT JOIN tbl_New_Admission NA 
                ON NA.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.New_Admission_Id
            WHERE (dbo.Tbl_Candidate_Personal_Det.Campus = @organization_id OR @organization_id = 0)
                  AND (NA.Department_Id = @Department_id OR @Department_id = 0)
                  AND (NA.Batch_Id = @intake_id OR @intake_id = 0)
                  AND ((Placement_status = '''' OR Placement_status IS NULL OR Placement_status = ''Fail'' OR Placement_status = ''AB'') 
                      AND dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus = 0) 
                  AND (dbo.Tbl_Candidate_Personal_Det.Candidate_Id LIKE ''%'' + @SearchKeyWord + ''%''
                      OR CONCAT(Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', Tbl_Candidate_Personal_Det.Candidate_Lname) LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR Tbl_Candidate_Personal_Det.AdharNumber LIKE ''%'' + @SearchKeyWord + ''%''
                      OR Placement_date LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR Tbl_Candidate_ContactDetails.Candidate_Email LIKE ''%'' + @SearchKeyWord + ''%'' 
                      OR @SearchKeyWord = '''')
        END
    END');
END;