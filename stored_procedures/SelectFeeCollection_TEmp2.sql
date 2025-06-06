IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SelectFeeCollection_TEmp2]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE [dbo].[SelectFeeCollection_TEmp2]
    (
        @CandidateId BIGINT,
        @intake BIGINT
    )
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @Cnt BIGINT;
        SET @Cnt = (SELECT COUNT(Fee_Entry_Id) 
                    FROM Tbl_Fee_Entry_Main 
                    WHERE Candidate_Id = @CandidateId 
                    AND IntakeId = @intake);
        
        IF (@Cnt > 0)
        BEGIN
            SELECT a.*, 
                   (SELECT TOP 1 Miscellaneous_due_date 
                    FROM Tbl_Fee_Entry_Main 
                    WHERE Candidate_Id = @CandidateId 
                    AND IntakeId = @intake 
                    AND TYP = a.Typ 
                    AND FeeHeadId = a.FeeHead_Id 
                    AND ItemDescription = a.ItemDescription 
                    AND ActiveStatus IS NOT NULL) AS Miscellaneous_due_date
            FROM (
                -- First Query
                SELECT Candidate_Id,
                       IntakeId AS Intake_Id,
                       FeeHeadId AS Feehead_Id,
                       Amount,
                       (SELECT TOP 1 Fee_Head_Name FROM dbo.Tbl_Fee_Head WHERE Fee_Head_Id = FM.FeeHeadId) AS FeeHeadName,
                       Currency,
                       typ,
                       ItemDescription,
                       Balance,
                       ISNULL(Paid, 0) AS Paid,
                       0 AS pay,
                       (SELECT TOP 1 Feecode FROM dbo.Tbl_FeecodeStudentMap WHERE Candidate_Id = @CandidateId AND Intake_Id = @intake) AS FeeCode,
                       (SELECT TOP 1 Course_Id FROM dbo.Tbl_FeecodeStudentMap WHERE Candidate_Id = @CandidateId AND Intake_Id = @intake) AS CourseId
                FROM Tbl_Fee_Entry_Main FM 
                WHERE FM.Candidate_Id = @CandidateId 
                AND FM.IntakeId = @intake 
                AND FM.ActiveStatus IS NULL
                
                UNION
                
                -- Second Query
                SELECT fc.Candidate_Id,
                       fc.Intake_Id,
                       fd.Feehead_Id,
                       fd.Amount,
                       fh1.Fee_Head_Name AS FeeHeadName,
                       fd.Currency,
                       ''Normal'' AS typ,
                       fd.ItemDescription,
                       fd.Amount AS Balance,
                       0 AS Paid,
                       0 AS pay,
                       FC.Feecode,
                       FC.Course_Id
                FROM TBL_FeeSettingsDetails FD
                INNER JOIN Tbl_Fee_Settings F ON f.Fee_Settings_Id = FD.Fee_Settings_Id
                INNER JOIN Tbl_Fee_Head fh1 ON fh1.Fee_Head_Id = fd.Feehead_Id
                INNER JOIN Tbl_FeecodeStudentMap FC ON fc.Feecode = f.Scheme_Code  
                WHERE fc.Candidate_Id = @CandidateId 
                AND fc.Intake_Id = @intake
                AND fd.Feehead_Id NOT IN (
                    SELECT FeeHeadId 
                    FROM Tbl_Fee_Entry_Main FM 
                    WHERE FM.Candidate_Id = @CandidateId 
                    AND FM.IntakeId = @intake 
                    AND FM.ItemDescription = fd.ItemDescription
                )
                
                UNION
                
                -- Third Query
                SELECT FCM.Candidate_Id,
                       FCM.Intake_Id,
                       fcomd.FeeHeadId AS Feehead_Id,
                       fcomd.Amount,
                       fh2.Fee_Head_Name AS FeeHeadName,
                       fcomd.CurrencyId AS Currency,
                       ''Compulsory'' AS typ,
                       fcomd.ItemDescription,
                       fcomd.Amount AS Balance,
                       0 AS Paid,
                       0 AS pay,
                       (SELECT TOP 1 Feecode FROM dbo.Tbl_FeecodeStudentMap WHERE Candidate_Id = @CandidateId AND Intake_Id = @intake) AS FeeCode,
                       FCM.Course_Id
                FROM Tbl_Fee_Compulsory fcom
                INNER JOIN Tbl_Fee_CompulsoryDetails fcomd ON fcom.CompulsoryFeeId = fcomd.CumpulsoryFeeId
                INNER JOIN Tbl_Fee_Head fh2 ON fh2.Fee_Head_Id = fcomd.FeeHeadId
                INNER JOIN Tbl_FeecodeStudentMap FCM ON FCM.Course_Id = fcom.CourseId
                WHERE FCM.Candidate_Id = @CandidateId 
                AND FCM.Intake_Id = @intake
                AND fcom.TypeOfStudent = (
                    SELECT TOP 1 TypeOfStudent 
                    FROM Tbl_Candidate_Personal_Det cp 
                    WHERE cp.Candidate_Id = @CandidateId
                )
                AND fcomd.FeeHeadId NOT IN (
                    SELECT FM.FeeHeadId 
                    FROM Tbl_Fee_Entry_Main FM 
                    WHERE FM.Candidate_Id = @CandidateId 
                    AND FM.IntakeId = @intake 
                    AND FM.ItemDescription = fcomd.ItemDescription
                )
            ) a;
        END
        ELSE
        BEGIN
            SELECT a.*, 
                   (SELECT TOP 1 Miscellaneous_due_date 
                    FROM Tbl_Fee_Entry_Main 
                    WHERE Candidate_Id = @CandidateId 
                    AND IntakeId = @intake 
                    AND TYP = a.Typ 
                    AND FeeHeadId = a.FeeHead_Id 
                    AND ItemDescription = a.ItemDescription) AS Miscellaneous_due_date
            FROM (
                -- First Query
                SELECT fc.Candidate_Id,
                       fc.Intake_Id,
                       fd.Feehead_Id,
                       fd.Amount,
                       fh1.Fee_Head_Name AS FeeHeadName,
                       fd.Currency,
                       ''Normal'' AS typ,
                       fd.ItemDescription,
                       fd.Amount AS Balance,
                       0 AS Paid,
                       0 AS pay,
                       (SELECT TOP 1 Feecode FROM dbo.Tbl_FeecodeStudentMap WHERE Candidate_Id = @CandidateId AND Intake_Id = @intake) AS FeeCode,
                       (SELECT TOP 1 Course_Id FROM dbo.Tbl_FeecodeStudentMap WHERE Candidate_Id = @CandidateId AND Intake_Id = @intake) AS CourseId
                FROM TBL_FeeSettingsDetails FD
                INNER JOIN Tbl_Fee_Settings F ON f.Fee_Settings_Id = FD.Fee_Settings_Id
                INNER JOIN Tbl_Fee_Head fh1 ON fh1.Fee_Head_Id = fd.Feehead_Id
                INNER JOIN Tbl_FeecodeStudentMap FC ON fc.Feecode = f.Scheme_Code  
                WHERE fc.Candidate_Id = @CandidateId 
                AND fc.Intake_Id = @intake
                
                UNION
                
                -- Second Query
                SELECT FCM.Candidate_Id,
                       FCM.Intake_Id,
                       fcomd.FeeHeadId AS Feehead_Id,
                       fcomd.Amount,
                       fh2.Fee_Head_Name AS FeeHeadName,
                       fcomd.CurrencyId AS Currency,
                       ''Compulsory'' AS typ,
                       fcomd.ItemDescription,
                       fcomd.Amount AS Balance,
                       0 AS Paid,
                       0 AS pay,
                       FCM.Feecode,
                       FCM.Course_Id
                FROM Tbl_Fee_Compulsory fcom
                INNER JOIN Tbl_Fee_CompulsoryDetails fcomd ON fcom.CompulsoryFeeId = fcomd.CumpulsoryFeeId
                INNER JOIN Tbl_Fee_Head fh2 ON fh2.Fee_Head_Id = fcomd.FeeHeadId
                INNER JOIN Tbl_FeecodeStudentMap FCM ON FCM.Course_Id = fcom.CourseId
                WHERE FCM.Candidate_Id = @CandidateId 
                AND FCM.Intake_Id = @intake
                AND fcom.TypeOfStudent = (
                    SELECT TOP 1 TypeOfStudent 
                    FROM Tbl_Candidate_Personal_Det cp 
                    WHERE cp.Candidate_Id = @CandidateId
                )
            ) a;
        END
    END';
END;
