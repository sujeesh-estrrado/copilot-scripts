IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_SelectIndividualStudentFeeReportSub_new_FINALS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Tbl_SelectIndividualStudentFeeReportSub_new_FINALS] --412,11846

AS
BEGIN
    --EXEC Sp_SelectIndividualStudentFeeReportSub_new_FINAL @candidateId,@intake
update Tbl_SelectIndividualStudentFeeReportSub_new_FINAL set TransferIn=''IN'' where TransferIn is NULL
update Tbl_SelectIndividualStudentFeeReportSub_new_FINAL set TransferInAmount=0.00 where TransferInAmount is NULL
update Tbl_SelectIndividualStudentFeeReportSub_new_FINAL set TransferOut=''OUT'' where TransferOut is NULL
update Tbl_SelectIndividualStudentFeeReportSub_new_FINAL set TranferOutAmount=0.00 where TranferOutAmount is NULL
SELECT * FROM Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
END
    ')
END;
GO
