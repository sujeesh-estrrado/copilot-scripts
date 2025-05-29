IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Print_FeeByStudent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Print_FeeByStudent]
@ReceiptNo BIGINT,
@Candidate_Id BIGINT
AS
BEGIN
    SELECT DISTINCT 
        FE.Fee_Entry_Id,
        FE.*,
        CBD.Batch_Code,
        D.Course_Code,
        FH.Fee_Head_Name,
        CASE FE.typ 
            WHEN ''MISC'' THEN FH.Fee_Head_Name + ''-'' + CONVERT(VARCHAR(10), GETDATE(), 103) + ''-'' + CONVERT(VARCHAR(8), GETDATE(), 108)
            WHEN ''Normal'' THEN FH.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode
            WHEN ''Compulsory'' THEN FH.Fee_Head_Name + ''-'' + D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CBD.Study_Mode
        END AS ItemDescription,
        
        CASE PD.Payment_Details_Mode
            WHEN ''1'' THEN ''CASH''
            WHEN ''2'' THEN ''CHEQUE''
            WHEN ''3'' THEN ''CREDIT CARD''
            WHEN ''4'' THEN ''EMGS''
            WHEN ''5'' THEN ''PTPTN Direct Debit''
            WHEN ''6'' THEN ''SALARY DEDUCTION''
            WHEN ''7'' THEN ''TELEGRAPHIC TRANSFER''
        END AS MOP,
        
        CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,
        FE.ReceiptNo
                
    FROM Tbl_Fee_Entry FE
    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = FE.IntakeId
    LEFT JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = FE.Candidate_Id
    LEFT JOIN dbo.Tbl_Department D ON D.Department_Id = SR.Department_Id
    INNER JOIN dbo.Tbl_Fee_Head FH ON FH.Fee_Head_Id = FE.FeeHeadId
    INNER JOIN dbo.Tbl_Fee_Entry_Details FD ON FD.Fee_Entry_Details_Id = FE.Feeid
    INNER JOIN dbo.Tbl_Payment_Details PD ON PD.Payment_Details_Particulars_Id = FE.Feeid
    INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = FE.Candidate_Id
    WHERE FE.ReceiptNo = @ReceiptNo 
    AND CPD.Candidate_Id = @Candidate_Id
END
');
END;