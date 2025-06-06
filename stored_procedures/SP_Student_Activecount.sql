IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Student_Activecount_Today]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Student_Activecount_Today]
        @date DATETIME,
        @TypeOfStudent VARCHAR(50) = '''', 
        @Typeinter VARCHAR(50) = ''''
        AS
        BEGIN
            SELECT 
                COUNT(DISTINCT CPD.Candidate_Id) AS PaidLocalCounts,
                (SELECT COUNT(DISTINCT CPD.Candidate_Id) 
                 FROM Tbl_Candidate_Personal_Det CPD
                 INNER JOIN student_transaction ST ON ST.studentid = CPD.Candidate_Id 
                 WHERE FeeStatus = ''paid''  
                   AND create_date = @date 
                   AND TypeOfStudent = @Typeinter) AS PaidInternationalCounts,
                (SELECT COUNT(*) 
                 FROM Tbl_Candidate_Personal_Det 
                 WHERE active = 3 
                   AND create_date = @date 
                   AND TypeOfStudent = @TypeOfStudent) AS LocalCounts,
                (SELECT COUNT(*) 
                 FROM Tbl_Candidate_Personal_Det 
                 WHERE active = 3 
                   AND create_date = @date 
                   AND TypeOfStudent = @TypeOfStudent) AS InternationalCounts
            FROM Tbl_Candidate_Personal_Det CPD
            INNER JOIN student_transaction ST ON ST.studentid = CPD.Candidate_Id
            WHERE create_date = @date 
              AND TypeOfStudent = @TypeOfStudent 
              AND FeeStatus = ''paid''
        END
    ')
END
