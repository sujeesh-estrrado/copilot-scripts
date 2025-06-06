IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SelectCGPA1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_SelectCGPA1]  
        (@Candidate_Id bigint)  
        AS  
        BEGIN  
            TRUNCATE TABLE TempTerm;  
            TRUNCATE TABLE tempMain;  
            TRUNCATE TABLE TempCredithrs;  
            TRUNCATE TABLE tempCGP;  

            INSERT INTO tempMain  
            SELECT DISTINCT EC.ExamCode,
                            SC.SubjectName,
                            SC.CurrentStatus,
                            SC.Term AS Exam_Term,
                            EC.Candidate_Id,
                            S.Contact_Hours AS timing,
                            EC.Grade,
                            GSS.GradePoint,
                            S.Credit_Points * GSS.GradePoint AS TotalGP,
                            GSS.Pass,
                            (SELECT TOP 1 ExamDate 
                             FROM dbo.Tbl_Exam_Code_Master EE  
                             INNER JOIN Tbl_Exam_Code_Child EX 
                             ON EE.Exam_Code_Master_Id = EX.Exam_Code_Master_Id  
                             WHERE EX.Exam_Code_final = EC.ExamCode) AS [Exam_date]                                 
            FROM Tbl_Exam_Mark_Entry_Child EC   
            INNER JOIN Tbl_StudentExamSubjectsChild SC 
            ON EC.ExamCode = SC.ExamCode  
            INNER JOIN Tbl_GradingScheme GS 
            ON GS.Grade_Scheme = SC.GradingScherme  
            INNER JOIN Tbl_GradeSchemeSetup GSS 
            ON GSS.Grade_Scheme_Id = GS.Grade_Scheme_Id 
            AND EC.Grade = GSS.Grade  
            INNER JOIN Tbl_GroupChangeExamDates GD 
            ON GD.ExamCode = EC.ExamCode  
            INNER JOIN Tbl_Subject S 
            ON SC.SubjectId = S.Subject_Id  
            INNER JOIN dbo.Tbl_Exam_Code_Child ECC 
            ON GD.ExamCode = ECC.Exam_Code_Final  
            INNER JOIN dbo.Tbl_Assessment_Type AT 
            ON AT.Assesment_Type = ECC.AssesmentType  
            INNER JOIN Tbl_Assessment_Code_Child ACC 
            ON ACC.Assessment_Type_Id = AT.Assessment_Type_Id  
            WHERE EC.Candidate_Id = @Candidate_Id  
            AND SC.CurrentStatus <> ''--Select--'' 
            AND last = 1;  

            INSERT INTO tempCGP  
            SELECT SUM(TotalGP) AS TotalGp,  
                   SUM(timing) AS CreditHrs,  
                   SUM(TotalGP) / SUM(timing) AS GPA,  
                   Exam_term  
            FROM tempMain  
            GROUP BY Exam_term;  

            INSERT INTO TempCredithrs  
            SELECT SUM(timing) AS TotCreditHrs, Exam_term  
            FROM tempMain  
            WHERE Pass = ''PASS''  
            GROUP BY Exam_term;  

            INSERT INTO TempTerm (Term)  
            SELECT Exam_term  
            FROM (SELECT DISTINCT(Exam_term), [Exam_date]  
                  FROM tempMain) a  
            ORDER BY [Exam_date] ASC;  

            DECLARE @count INT,  
                    @iCount INT,  
                    @TotalCredithrs DECIMAL(18,2),  
                    @TotalCGPA DECIMAL(18,2),  
                    @TotalCGPAhrs INT,  
                    @TotalCGPATothrs INT,  
                    @CumTotalCredithrs DECIMAL(18,2),  
                    @CumTotalCGPA DECIMAL(18,2),  
                    @CurrentRow VARCHAR(50);  

            SET @iCount = 0;  
            SET @CurrentRow = 0;  
            SET @TotalCredithrs = 0;  
            SET @TotalCGPA = 0;  
            SET @CumTotalCGPA = 0;  
            SET @CumTotalCredithrs = 0;  
            SET @TotalCGPAhrs = 0;  
            SET @TotalCGPATothrs = 0;  

            SELECT @count = COUNT(RID) FROM TempTerm;  

            WHILE @iCount < @count  
            BEGIN  
                SELECT @CurrentRow = Term  
                FROM TempTerm  
                WHERE RID = @iCount + 1;  

                SELECT @TotalCredithrs = TotCreditHrs  
                FROM TempCredithrs  
                WHERE Exam_term = @CurrentRow;  

                SELECT @TotalCGPA = TotalGP, @TotalCGPAhrs = Credithrs  
                FROM tempCGP  
                WHERE Exam_term = @CurrentRow;  

                SET @CumTotalCredithrs = @CumTotalCredithrs + @TotalCredithrs;  
                SET @CumTotalCGPA = @CumTotalCGPA + @TotalCGPA;  
                SET @TotalCGPATothrs = @TotalCGPATothrs + @TotalCGPAhrs;  

                UPDATE TempTerm  
                SET TotalCreditHours = @CumTotalCredithrs,  
                    CGPA = @CumTotalCGPA / @TotalCGPATothrs  
                WHERE RID = @iCount + 1;  

                SET @iCount = @iCount + 1;  
            END  

            SELECT DISTINCT T1.*,  
                            T2.TotalCreditHours,  
                            T2.CGPA,  
                            T3.GPA  
            FROM tempMain T1  
            INNER JOIN TempTerm T2 
            ON T1.Exam_Term = T2.Term  
            INNER JOIN tempCGP T3  
            ON T1.Exam_Term = T3.Exam_Term;  

        END
    ')
END
