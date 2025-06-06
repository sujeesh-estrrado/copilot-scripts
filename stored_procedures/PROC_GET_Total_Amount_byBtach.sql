IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PROC_GET_Total_Amount_byBtach]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[PROC_GET_Total_Amount_byBtach] 
        (@Duration_Mapping_Id BIGINT, @date DATETIME)
        AS
        BEGIN
            SELECT DISTINCT 
                a.Batch_Id,
                A.BatchSemester,
                A.Batch_Code,
                SUM(A.Amountobepaid) AS Amountobepaid,
                SUM(A.Paid) AS paid,
                SUM(A.balance) AS dueamount 
            FROM (
                SELECT DISTINCT 
                    CPD.Candidate_Id,
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,
                    CPD.AdharNumber,
                    CBD.Batch_Code,
                    FSD.Amount AS Amountobepaid,
                    FSD.ItemDescription,
                    ISNULL(FEM.Paid, 0) AS Paid,
                    D.Course_Code,
                    FSD.Feehead_Id,
                    FSD.Amount - ISNULL(FEM.Paid, 0) AS balance,
                    CBD.Batch_Id,
                    D.Department_Name,
                    D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CS.Semester_Code AS BatchSemester,
                    CONVERT(VARCHAR(50), CBD.Batch_From, 103) AS Batch_From,
                    FSD.Period_In_Days,
                    CONVERT(VARCHAR(50), DATEADD(dd, FSD.Period_In_Days, CBD.Batch_From), 103) AS duedate,
                    D.Department_Id
                FROM dbo.Tbl_Candidate_Personal_Det CPD
                INNER JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
                INNER JOIN dbo.Tbl_Department D ON SR.Department_Id = D.Department_Id
                INNER JOIN dbo.Tbl_FeecodeStudentMap FSMP ON FSMP.Candidate_Id = CPD.Candidate_Id
                INNER JOIN dbo.Tbl_Fee_Settings FS ON FS.Scheme_Code = FSMP.Feecode
                INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
                INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = FSMP.Intake_Id
                INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SS.Duration_Mapping_Id
                INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
                INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
                INNER JOIN dbo.TBL_FeeSettingsDetails FSD ON FSD.Fee_Settings_Id = FS.Fee_Settings_Id
                LEFT JOIN dbo.Tbl_Fee_Entry_Main FEM ON FEM.Candidate_Id = CPD.Candidate_Id
                    AND FEM.ItemDescription = FSD.ItemDescription
                    AND FEM.FeeHeadId = FSD.Feehead_Id
                    AND FEM.Amount = FSD.Amount
                    AND FEM.ActiveStatus IS NULL
                WHERE 
                    CONVERT(DATETIME, DATEADD(dd, FSD.Period_In_Days, CBD.Batch_From), 103) < @date
                    AND FEM.IntakeId = @Duration_Mapping_Id
                GROUP BY 
                    FSD.Feehead_Id, 
                    CPD.Candidate_Id, 
                    CPD.Candidate_Fname, 
                    CPD.Candidate_Mname, 
                    CPD.Candidate_Lname,
                    CPD.AdharNumber, 
                    CBD.Batch_Code, 
                    FSD.Amount, 
                    D.Department_Name, 
                    FSD.Period_In_Days, 
                    CBD.Batch_From, 
                    FSD.ItemDescription, 
                    FEM.Paid, 
                    D.Department_Id, 
                    CS.Semester_Code, 
                    CDM.Duration_Mapping_Id, 
                    CBD.Batch_Id, 
                    D.Course_Code
            ) A
            GROUP BY A.Batch_Id, A.BatchSemester, A.Batch_Code
        END
    ')
END
