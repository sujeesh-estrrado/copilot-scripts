IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Indidvidual_Fee_ByStudent_Sub]') 
    AND type = N'P'
)
BEGIN
    DECLARE @sql NVARCHAR(MAX) = N'
    CREATE PROCEDURE [dbo].[Indidvidual_Fee_ByStudent_Sub] 
    (@candidateId bigint,                
    @intake bigint,
    @Feehead_Id bigint)                
    AS                
    BEGIN                
    SELECT DISTINCT tabSub.*, tabSub.Paid AS Paid1, tabSub.Date AS Date1, tabMain.Amount 
    FROM (
        SELECT A.Candidate_Id, A.Intake_Id, A.Feehead_Id, A.FeeHeadName, A.Currency,        
        A.CurrencyCode, A.CANDIDNAME, A.Course_Code, A.Batch_Code, A.Study_Mode, A.ItemDesc,
        ISNULL(A.Discount, 0) AS Discount, ISNULL(A.Refund, 0) AS Refund, SUM(Amount) AS Amount
        FROM (
            SELECT fc.Candidate_Id, fc.Intake_Id, fd.Feehead_Id, fd.Amount, fh1.Fee_Head_Name AS FeeHeadName,
            fd.Currency, C.CurrencyCode, CPD.Candidate_Fname + '' '' + ISNULL(CPD.Candidate_Mname, '''') + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
            D.Course_Code, ''Normal'' AS typ, fd.ItemDescription, FM.Discount, FM.Refund, CBD.Batch_Code, CBD.Study_Mode,
            fh1.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode AS ItemDesc
            FROM TBL_FeeSettingsDetails FD
            INNER JOIN Tbl_Fee_Settings F ON F.Fee_Settings_Id = FD.Fee_Settings_Id
            INNER JOIN dbo.Tbl_Fee_Entry FM ON FD.Feehead_Id = FM.FeeHeadId
            INNER JOIN Tbl_Fee_Head fh1 ON fh1.Fee_Head_Id = fd.Feehead_Id
            INNER JOIN Tbl_FeecodeStudentMap FC ON fc.Feecode = f.Scheme_Code
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = fc.Candidate_Id
            INNER JOIN Tbl_Student_Registration SR ON SR.Candidate_Id = CPD.Candidate_Id
            INNER JOIN Tbl_Currency C ON C.Currency_Id = fd.Currency
            INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = fc.Intake_Id
            INNER JOIN Tbl_Department D ON D.Department_Id = SR.Department_Id
            WHERE fc.Candidate_Id = @candidateId 
            AND fd.Feehead_Id IS NOT NULL 
            AND fc.Intake_Id = @intake 
            AND fd.Feehead_Id = @Feehead_Id
        ) A
        GROUP BY A.Candidate_Id, A.Intake_Id, A.Feehead_Id, A.FeeHeadName, A.Currency,
        A.CurrencyCode, A.CANDIDNAME, A.Course_Code, A.Batch_Code, A.Study_Mode, A.ItemDesc, A.Discount, A.Refund
    ) TabMain
    END'
    EXEC sp_executesql @sql
END
