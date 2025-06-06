IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ENROLLMET_REPORT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_ENROLLMET_REPORT] 
            @Fromdate DATETIME, 
            @Todate DATETIME
        AS 
        BEGIN 
            SELECT DISTINCT 
                CPD.Candidate_Id,
                CONVERT(VARCHAR(50), CPD.RegDate, 103) AS ENROLLDATE,
                CPD.EnrollBy,
                D.Course_Code,
                CBD.Batch_Code,
                CBD.Study_Mode,
                CPD.AdharNumber,
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CANDIDATENAME,
                (SELECT ISNULL(SUM(FE.Paid), 0) 
                 FROM dbo.Tbl_Fee_Entry_Main FE 
                 WHERE FE.Candidate_Id = CPD.Candidate_Id) AS PAIDAMOUNT
            FROM dbo.Tbl_Candidate_Personal_Det CPD
            INNER JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = SR.Department_Id
            INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SS.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
            WHERE SS.Student_Semester_Current_Status = 1 
            AND CPD.RegDate >= @Fromdate 
            AND CPD.RegDate <= @Todate
            GROUP BY 
                CPD.Candidate_Id,
                CPD.RegDate,
                CPD.EnrollBy,
                D.Course_Code,
                CBD.Batch_Code,
                CBD.Study_Mode,
                CPD.AdharNumber,
                CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname
        END
    ')
END
