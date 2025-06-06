IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectIndividualStudentFeeReportSub_new_back]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectIndividualStudentFeeReportSub_new_back]
            (@candidateId BIGINT, @intake BIGINT)
        AS
        BEGIN
            -- Select distinct records and calculate the necessary details
            SELECT DISTINCT 
                tabSub.*, 
                tabSub.Paid AS Paid1,
                tabSub.Date AS Date1, 
                tabMain.Amount 
            FROM (
                SELECT 
                    A.Candidate_Id,
                    A.Intake_Id,
                    A.Feehead_Id, 
                    A.FeeHeadName,
                    A.Currency,
                    A.CurrencyCode,
                    A.CANDIDNAME,
                    A.Course_Code,
                    A.Batch_Code,
                    A.Study_Mode,
                    A.ItemDesc,
                    ISNULL(A.Discount, 0) AS Discount,
                    ISNULL(A.Refund, 0) AS Refund,
                    SUM(Amount) AS Amount
                FROM (
                    -- Subquery for FeeSettingsDetails and related tables
                    SELECT DISTINCT 
                        fc.Candidate_Id,
                        fc.Intake_Id,
                        fd.Feehead_Id,
                        fd.Amount,
                        fh1.Fee_Head_Name AS FeeHeadName,
                        fd.Currency,
                        C.CurrencyCode,
                        CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
                        D.Course_Code,
                        ''Normal'' AS typ,
                        fd.ItemDescription,
                        FM.Discount,
                        FM.Refund,
                        CBD.Batch_Code,
                        CBD.Study_Mode,
                        fh1.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode AS ItemDesc
                    FROM 
                        TBL_FeeSettingsDetails FD
                    INNER JOIN Tbl_Fee_Settings F ON F.Fee_Settings_Id = FD.Fee_Settings_Id
                    INNER JOIN [Tbl_Fee_Entry_Main] FEM ON FD.Feehead_Id = FEM.FeeHeadId
                        AND FEM.Candidate_Id = @candidateId
                        AND FEM.IntakeId = @intake
                    INNER JOIN dbo.Tbl_Fee_Entry FM ON FM.FeeHeadId = FEM.FeeHeadId
                        AND FEM.ItemDescription = FM.ItemDesc
                        AND FM.Paid IS NOT NULL
                        AND FM.Candidate_Id = FEM.Candidate_Id
                        AND FM.IntakeId = FEM.IntakeId
                    INNER JOIN Tbl_Fee_Head fh1 ON fh1.Fee_Head_Id = fd.Feehead_Id
                    INNER JOIN Tbl_FeecodeStudentMap FC ON fc.Feecode = f.Scheme_Code
                    INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = fc.Candidate_Id
                    INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
                    INNER JOIN Tbl_Currency C ON C.Currency_Id = fd.Currency
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = fc.Intake_Id
                    INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
                    WHERE 
                        fc.Candidate_Id = @candidateId
                        AND fd.Feehead_Id IS NOT NULL
                        AND fc.Intake_Id = @intake
                    UNION
                    -- Subquery for FeeCompulsory and related tables
                    SELECT 
                        FCM.Candidate_Id,
                        FCM.Intake_Id,
                        fcomd.FeeHeadId AS Feehead_Id,
                        fcomd.Amount,
                        fh2.Fee_Head_Name AS FeeHeadName,
                        fcomd.CurrencyId AS Currency,
                        C.CurrencyCode,
                        CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
                        D.Course_Code,
                        ''Compulsory'' AS typ,
                        fcomd.ItemDescription,
                        ISNULL(FM.Discount, 0) AS Discount,
                        ISNULL(FM.Refund, 0) AS Refund,
                        CBD.Batch_Code,
                        CBD.Study_Mode,
                        fh2.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode AS ItemDesc
                    FROM 
                        Tbl_Fee_Compulsory fcom
                    INNER JOIN Tbl_Fee_CompulsoryDetails fcomd ON fcom.CompulsoryFeeId = fcomd.CumpulsoryFeeId
                    INNER JOIN Tbl_Fee_Head fh2 ON fh2.Fee_Head_Id = fcomd.FeeHeadId
                    INNER JOIN Tbl_FeecodeStudentMap FCM ON FCM.Course_Id = fcom.CourseId
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = FCM.Intake_Id
                    INNER JOIN Tbl_Currency C ON C.Currency_Id = fcomd.CurrencyId
                    INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FCM.Candidate_Id
                    INNER JOIN [Tbl_Fee_Entry_Main] FEM ON FCM.Candidate_Id = FEM.Candidate_Id
                    INNER JOIN dbo.Tbl_Fee_Entry FM ON FM.FeeHeadId = FEM.FeeHeadId
                        AND FEM.ItemDescription = FM.ItemDesc
                        AND FM.Paid IS NOT NULL
                        AND FM.Candidate_Id = FEM.Candidate_Id
                        AND FM.IntakeId = FEM.IntakeId
                    INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
                    INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
                    WHERE 
                        FCM.Candidate_Id = @candidateId
                        AND fcomd.FeeheadId IS NOT NULL
                        AND FCM.Intake_Id = @intake
                        AND fcom.TypeOfStudent = (
                            SELECT TypeOfStudent 
                            FROM Tbl_Candidate_Personal_Det cp 
                            WHERE cp.Candidate_Id = @candidateId
                        )
                    UNION
                    -- Subquery for FeeEntryMain and related tables
                    SELECT 
                        FM.Candidate_Id,
                        FM.IntakeId AS Intake_Id,
                        FM.FeeHeadId,
                        FM.Amount,
                        fh3.Fee_Head_Name AS FeeHeadName,
                        FM.Currency,
                        C.CurrencyCode,
                        CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
                        D.Course_Code,
                        FM.typ,
                        FM.ItemDescription,
                        ISNULL(FE.Discount, 0) AS Discount,
                        ISNULL(FE.Refund, 0) AS Refund,
                        CBD.Batch_Code,
                        CBD.Study_Mode,
                        fh3.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode AS ItemDesc
                    FROM 
                        Tbl_Fee_Entry_Main FM
                    INNER JOIN Tbl_Fee_Head fh3 ON fh3.Fee_Head_Id = FM.FeeHeadId
                    INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FM.Candidate_Id
                    INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = FM.IntakeId
                    INNER JOIN Tbl_Currency C ON C.Currency_Id = FM.Currency
                    INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
                    INNER JOIN dbo.Tbl_Fee_Entry FE ON FE.Fee_Entry_Id = FM.Fee_Entry_Id
                        AND FM.Paid IS NOT NULL
                    WHERE 
                        FM.typ = ''MISC''
                        AND FM.Candidate_Id = @candidateId
                        AND FM.FeeHeadId IS NOT NULL
                        AND FM.IntakeId = @intake
                ) A
                GROUP BY 
                    A.Candidate_Id,
                    A.Intake_Id,
                    A.Feehead_Id,
                    A.FeeHeadName,
                    A.Currency,
                    A.CurrencyCode,
                    A.CANDIDNAME,
                    A.Course_Code,
                    A.Batch_Code,
                    A.Study_Mode,
                    A.ItemDesc,
                    A.Discount,
                    A.Refund
            ) TabMain
            RIGHT JOIN (
                -- Subquery for FeeEntryMain and Payment Details
                SELECT DISTINCT 
                    FE.FeeHeadId AS Feehead_Id,
                    FE.Amount,
                    FEM.ItemDescription,
                    ISNULL(FE.Discount, 0) AS Discount,
                    ISNULL(FE.Refund, 0) AS Refund,
                    FH.Fee_Head_Name + ''-'' + CASE PD.Payment_Details_Mode
                        WHEN ''1'' THEN ''CASH-Payment''
                        WHEN ''2'' THEN ''CHEQUE-Payment''
                        WHEN ''3'' THEN ''DD-Payment''
                        WHEN ''7'' THEN ''RTGS-Payment''
                    END AS ItemDesc,
                    Fe.Currency,
                    ISNULL(FE.Paid, 0) AS Paid,
                    FE.[Date],
                    C.CurrencyCode,
                    FE.Candidate_Id,
                    FE.IntakeId AS Intake_Id
                FROM 
                    Tbl_Fee_Entry_Main FEM
                INNER JOIN Tbl_Fee_Entry FE ON FE.FeeHeadId = FEM.FeeHeadId
                    AND FEM.ItemDescription = FE.ItemDesc
                    AND FE.Paid IS NOT NULL
                    AND FE.Candidate_Id = FEM.Candidate_Id
                    AND FE.IntakeId = FEM.IntakeId
                LEFT JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id = FE.FeeHeadId
                LEFT JOIN Tbl_Currency C ON C.Currency_Id = FE.Currency
                LEFT JOIN dbo.Tbl_Payment_Details PD ON PD.Payment_Details_Particulars_Id = FE.Feeid
                WHERE 
                    FE.Candidate_Id = @candidateId
                    AND FEM.ItemDescription IS NOT NULL
                    AND FE.IntakeId = @intake
            ) TabSub 
            ON TabMain.ItemDesc = TabSub.ItemDesc
        END
    ')
END
