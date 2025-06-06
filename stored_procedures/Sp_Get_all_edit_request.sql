IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_edit_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_edit_request] 
        (@flag BIGINT = 0, 
         @CurrentPage INT = NULL, 
         @pagesize BIGINT = NULL, 
         @empid BIGINT = 0)
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                -- First part of the query (when flag is 0)
                SELECT 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID,
                    CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) AS CandidateName,
                    dbo.Tbl_Candidate_Personal_Det.ApplicationStatus,
                    dbo.Tbl_Candidate_Personal_Det.Edit_request, 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber,
                    dbo.Tbl_Candidate_Personal_Det.Candidate_Id AS ID,  
                    dbo.Tbl_Candidate_Personal_Det.Edit_request_remark
                FROM dbo.Tbl_Candidate_Personal_Det 
                INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                    ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                WHERE dbo.Tbl_Candidate_Personal_Det.Edit_request = 1 
                    AND Candidate_DelStatus = 0 
                    AND (Editable = 0 OR Editable IS NULL) 
                    AND ApplicationStatus NOT IN (''submited'', ''Hold'', ''Completed'') 
                UNION ALL
                SELECT 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID,
                    CONCAT(P.Candidate_Fname, '' '', P.Candidate_Lname) AS CandidateName, 
                    N.ApplicationStatus,
                    N.Edit_request, 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber,
                    N.Candidate_Id AS ID,  
                    N.Edit_request_remark
                FROM Tbl_Student_NewApplication N
                INNER JOIN dbo.Tbl_Candidate_Personal_Det P 
                    ON N.Candidate_Id = P.Candidate_Id
                INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                    ON N.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                WHERE N.Edit_request = 1 
                    AND N.Candidate_DelStatus = 0 
                    AND (N.Editable = 0 OR N.Editable IS NULL) 
                    AND N.ApplicationStatus NOT IN (''submited'', ''Hold'', ''Completed'')
                ORDER BY ID DESC  
                OFFSET @pagesize * (@CurrentPage - 1) ROWS
                FETCH NEXT @pagesize ROWS ONLY
            END

            IF (@flag = 1)
            BEGIN
                -- Second part of the query (when flag is 1)
                SELECT COUNT(*) AS counts
                FROM (
                    SELECT COUNT(dbo.Tbl_Candidate_Personal_Det.Candidate_Id) AS counts
                    FROM dbo.Tbl_Candidate_Personal_Det 
                    INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                        ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                    WHERE dbo.Tbl_Candidate_Personal_Det.Edit_request = 1 
                        AND Candidate_DelStatus = 0 
                        AND (Editable = 0 OR Editable IS NULL) 
                        AND ApplicationStatus NOT IN (''submited'', ''Hold'', ''Completed'')
                    UNION ALL
                    SELECT COUNT(N.Candidate_Id) AS counts
                    FROM dbo.Tbl_Student_NewApplication N
                    INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                        ON N.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                    WHERE N.Edit_request = 1 
                        AND N.Candidate_DelStatus = 0 
                        AND (N.Editable = 0 OR N.Editable IS NULL) 
                        AND N.ApplicationStatus NOT IN (''submited'', ''Hold'', ''Completed'')
                ) AS tem
            END

            IF (@flag = 2)
            BEGIN
                -- Third part of the query (when flag is 2)
                SELECT 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID,
                    CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) AS CandidateName, 
                    dbo.Tbl_Candidate_Personal_Det.ApplicationStatus,
                    dbo.Tbl_Candidate_Personal_Det.Edit_request, 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber, 
                    dbo.Tbl_Candidate_Personal_Det.Candidate_Id AS ID,
                    dbo.Tbl_Candidate_Personal_Det.Edit_request_remark
                FROM dbo.Tbl_Candidate_Personal_Det 
                INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                    ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                WHERE dbo.Tbl_Candidate_Personal_Det.Edit_request = 1 
                    AND Candidate_DelStatus = 0 
                    AND (Editable = 0 OR Editable IS NULL) 
                    AND ApplicationStatus IN (''submited'', ''pending'', ''Pending'') 
                    AND Counseloremployee_id = @empid
                UNION ALL
                SELECT 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Email AS EmailID,
                    CONCAT(dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, '' '', dbo.Tbl_Candidate_Personal_Det.Candidate_Lname) AS CandidateName, 
                    N.ApplicationStatus,
                    N.Edit_request, 
                    dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1 AS MobileNumber, 
                    N.Candidate_Id AS ID,  
                    N.Edit_request_remark
                FROM Tbl_Student_NewApplication N
                INNER JOIN dbo.Tbl_Candidate_Personal_Det 
                    ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = N.Candidate_Id
                INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                    ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
                WHERE N.Edit_request = 1 
                    AND N.Candidate_DelStatus = 0 
                    AND (N.Editable = 0 OR N.Editable IS NULL) 
                    AND N.ApplicationStatus IN (''submited'', ''pending'', ''Pending'') 
                    AND N.Counseloremployee_id = @empid
                ORDER BY ID DESC  
                OFFSET @pagesize * (@CurrentPage - 1) ROWS
                FETCH NEXT @pagesize ROWS ONLY
            END
        END
    ')
END
