IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[REPORTINTAKEWISE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[REPORTINTAKEWISE] 
            (@IntakeId BIGINT)
        AS
        BEGIN
            SELECT 
                SUM(A.Amount) AS Amounttobepaid,
                A.Candidate_Id,
                [Name],
                A.AdharNumber,
                (
                    SELECT ISNULL(SUM(FM.Paid), 0) 
                    FROM Tbl_Fee_Entry_Main FM 
                    WHERE FM.Candidate_Id = A.Candidate_Id 
                        AND FM.ActiveStatus IS NULL
                ) AS PaidAmount,
                SUM(A.Amount) - (
                    SELECT ISNULL(SUM(FM.Paid), 0) 
                    FROM Tbl_Fee_Entry_Main FM 
                    WHERE FM.Candidate_Id = A.Candidate_Id 
                        AND FM.ActiveStatus IS NULL
                ) AS Balance
            FROM (
                -- First UNION
                SELECT 
                    fc.Candidate_Id,
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS [Name],
                    CPD.AdharNumber,
                    SUM(FD.Amount) AS Amount
                FROM TBL_FeeSettingsDetails FD
                INNER JOIN Tbl_Fee_Settings F ON F.Fee_Settings_Id = FD.Fee_Settings_Id
                INNER JOIN Tbl_Fee_Head fh1 ON fh1.Fee_Head_Id = FD.Feehead_Id
                INNER JOIN Tbl_FeecodeStudentMap FC ON FC.Feecode = F.Scheme_Code
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FC.Candidate_Id
                WHERE FC.Intake_Id = @IntakeId
                GROUP BY CPD.Candidate_Fname, CPD.Candidate_Mname, CPD.Candidate_Lname, CPD.AdharNumber, FC.Candidate_Id

                UNION

                -- Second UNION
                SELECT 
                    FCM.Candidate_Id,
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS [Name],
                    CPD.AdharNumber,
                    SUM(fcomd.Amount) AS Amount
                FROM Tbl_Fee_Compulsory fcom
                INNER JOIN Tbl_Fee_CompulsoryDetails fcomd ON fcom.CompulsoryFeeId = fcomd.CumpulsoryFeeId
                INNER JOIN Tbl_Fee_Head fh2 ON fh2.Fee_Head_Id = fcomd.FeeHeadId
                INNER JOIN Tbl_FeecodeStudentMap FCM ON FCM.Course_Id = fcom.CourseId
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FCM.Candidate_Id 
                    AND CPD.TypeOfStudent = fcom.TypeOfStudent
                WHERE FCM.Intake_Id = @IntakeId
                GROUP BY CPD.Candidate_Fname, CPD.Candidate_Mname, CPD.Candidate_Lname, CPD.AdharNumber, FCM.Candidate_Id

                UNION

                -- Third UNION
                SELECT 
                    FM.Candidate_Id,
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS [Name],
                    CPD.AdharNumber,
                    SUM(FM.Amount) AS Amount
                FROM Tbl_Fee_Entry_Main FM
                INNER JOIN Tbl_Fee_Head fh3 ON fh3.Fee_Head_Id = FM.FeeHeadId
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FM.Candidate_Id
                INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = FM.IntakeId
                INNER JOIN Tbl_Currency C ON C.Currency_Id = FM.Currency
                INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
                WHERE FM.typ = ''MISC'' 
                    AND FM.ActiveStatus IS NULL 
                    AND FM.IntakeId = @IntakeId
                GROUP BY CPD.Candidate_Fname, CPD.Candidate_Mname, CPD.Candidate_Lname, CPD.AdharNumber, FM.Candidate_Id
            ) A
            GROUP BY A.Candidate_Id, [Name], A.AdharNumber
        END
    ')
END
