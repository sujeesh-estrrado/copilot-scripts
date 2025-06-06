IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectIndividualStudentFeeReportSub_new_FINALS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectIndividualStudentFeeReportSub_new_FINALS]
        AS
        BEGIN
            -- EXEC Sp_SelectIndividualStudentFeeReportSub_new_FINAL @candidateId, @intake
            
            -- Update records where TransferIn is NULL
            UPDATE Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
            SET TransferIn = ''IN''
            WHERE TransferIn IS NULL;
            
            -- Update records where TransferInAmount is NULL
            UPDATE Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
            SET TransferInAmount = 0.00
            WHERE TransferInAmount IS NULL;
            
            -- Update records where TransferOut is NULL
            UPDATE Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
            SET TransferOut = ''OUT''
            WHERE TransferOut IS NULL;
            
            -- Update records where TransferOutAmount is NULL
            UPDATE Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
            SET TranferOutAmount = 0.00
            WHERE TranferOutAmount IS NULL;
            
            -- Select all records from Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
            SELECT * 
            FROM Tbl_SelectIndividualStudentFeeReportSub_new_FINAL;
            -- WHERE Paid <> 0 OR Discount <> 0 OR Refund <> 0; -- Uncomment if necessary
        END
    ')
END
