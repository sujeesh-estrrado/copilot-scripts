IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetOfferLetterDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[GetOfferLetterDetails]
            @Candidate_Id INT
        AS
        BEGIN
            -- Original queries and logic
            SELECT 
                CASE WHEN TOL.offeracceptstatus = 1 THEN ''YES'' ELSE ''-NA-'' END AS Offerletter_status,
                CASE WHEN AL.Offerletter_sent = 1 THEN ''YES'' ELSE ''-NA-'' END AS Offerletter_sent, tol.temppath,
                TG.Template_name AS Offerlettername,
                tol.Senddate as Sentdate, sendby as Sented_by, TE.Employee_FName, 
                CASE WHEN TOL.sendby = 1 THEN ''Admin'' ELSE CONCAT(TE.Employee_FName, '' '', TE.Employee_LName) END AS name,
                CASE WHEN TOL.acceptdate IS NOT NULL THEN TOL.acceptdate ELSE ''5555-01-01'' END AS offerletteracceptdate,
                TOL.status, TOL.offeracceptstatus,
                OL.Resend_offerletter
            FROM tbl_approval_log AL
            JOIN Tbl_offerletter_log TOL ON TOL.candidateid = AL.candidate_id
            LEFT JOIN Tbl_Employee_User TEU ON TEU.User_Id = TOL.sendby
            LEFT JOIN Tbl_Employee TE ON TE.Employee_Id = TEU.Employee_Id
            LEFT JOIN Tbl_Template_generation TG ON TG.Template_id = TOL.template_id
            LEFT JOIN Tbl_Offerlettre OL ON OL.candidate_id = AL.candidate_id
            WHERE TOL.candidateid = @Candidate_Id
            ORDER BY tol.Senddate;
        END
    ')
END;
