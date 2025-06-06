IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Candidate_Fee_Details_Report_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Candidate_Fee_Details_Report_By_Date] 
        (@FromDate datetime, @ToDate datetime)
        AS
        BEGIN
            SELECT A.CandidateName, A.AdharNumber, A.Date, A.Fee_Head_Name, A.Batch, A.MOP, 
                A.Feeid, A.Remarks, A.TagDescription, A.AmountPaid, A.ReceiptNo
            FROM (
                (
                    SELECT 
                        cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName, 
                        cpd.AdharNumber, CONVERT(varchar(50), fe.Date, 103) AS Date, fh.Fee_Head_Name, 
                        D.Course_Code + ''-'' + cbd.Batch_Code AS Batch, 
                        fe.MOP, fe.Feeid, fe.Remarks, fe.ReceiptNo, fe.TagDescription, SUM(fe.Paid) AS AmountPaid
                    FROM dbo.Tbl_Fee_Entry fe
                    INNER JOIN dbo.Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = fe.Candidate_Id
                    INNER JOIN dbo.Tbl_Fee_Head fh ON fh.Fee_Head_Id = fe.FeeHeadId
                    INNER JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = fe.Candidate_Id
                    INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = fe.IntakeId
                    INNER JOIN dbo.Tbl_Department AS d ON d.Department_Id = SR.Department_Id
                    WHERE fe.Date >= @FromDate AND fe.Date <= @ToDate
                    GROUP BY cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname,
                        cpd.AdharNumber, CONVERT(varchar(50), fe.Date, 103), fh.Fee_Head_Name, 
                        D.Course_Code + ''-'' + cbd.Batch_Code, fe.MOP, fe.Feeid, fe.TagDescription, 
                        fe.Remarks, fe.ReceiptNo
                )
                UNION
                (
                    SELECT 
                        cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName, 
                        cpd.AdharNumber, CONVERT(varchar(50), fe.Date, 103) AS Date, fh.Fee_Head_Name, 
                        D.Course_Code + ''-'' + cbd.Batch_Code AS Batch, 
                        fe.MOP, fe.Feeid, fe.Remarks, fe.ReceiptNo, fe.TagDescription, SUM(fe.Paid) AS AmountPaid
                    FROM dbo.Tbl_Fee_Entry fe
                    INNER JOIN dbo.Tbl_Candidate_Personal_Det cpd ON cpd.Candidate_Id = fe.Candidate_Id
                    INNER JOIN dbo.Tbl_Fee_Head fh ON fh.Fee_Head_Id = fe.FeeHeadId
                    INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id = cpd.New_Admission_Id
                    INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
                    INNER JOIN dbo.Tbl_Department AS d ON d.Department_Id = NA.Department_Id
                    WHERE fe.Date >= @FromDate AND fe.Date <= @ToDate
                    GROUP BY cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname,
                        cpd.AdharNumber, CONVERT(varchar(50), fe.Date, 103), fh.Fee_Head_Name, 
                        D.Course_Code + ''-'' + cbd.Batch_Code, fe.MOP, fe.Feeid, fe.Remarks, 
                        fe.TagDescription, fe.ReceiptNo
                )
            ) A
        END
    ')
END
