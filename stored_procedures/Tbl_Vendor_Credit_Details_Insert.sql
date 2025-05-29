IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_Vendor_Credit_Details_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Tbl_Vendor_Credit_Details_Insert] 
@Ventor_Id bigint,
@Grand_Total decimal(18,2),
@Payment_Amount decimal(18,2),
@ApprovalId bigint,
@Credit_Or_Debit bit,
@CreditDetails_DelStatus bit,
@PayDate datetime

AS 
 DECLARE @PendingAmount as Decimal(18,2)
BEGIN
   SET @PendingAmount =ISNULL((SELECT Total_Amount FROM Tbl_Vendor_Credit_Details 
													WHERE Vendor_Id=@Ventor_Id and CreditDetails_DelStatus=0 ),0)
--   IF(@PendingAmount<>0)
--      BEGIN
      -- IF PURCHASE ADD Amount ELSE IF PAYMENT DEDUCT Amount
      IF (@Credit_Or_Debit=0)
          BEGIN
          SET @PendingAmount=@PendingAmount+(@Grand_Total-@Payment_Amount)
          print ''hi''
          END 
      ELSE IF(@Credit_Or_Debit=1)
          BEGIN
          SET @PendingAmount=@PendingAmount-(@Grand_Total-@Payment_Amount)
         print ''h0''
          END
     -- END
   UPDATE Tbl_Vendor_Credit_Details SET CreditDetails_DelStatus=1 where Vendor_Id=@Ventor_Id and CreditDetails_DelStatus=0
   INSERT INTO Tbl_Vendor_Credit_Details
  (Vendor_Id,Amount,Total_Amount,Payment_Approval_Id,Date,Credit_Or_Debit,CreditDetails_DelStatus)
   VALUES(@Ventor_Id,@Grand_Total-@Payment_Amount,@PendingAmount,@ApprovalId,@PayDate,@Credit_Or_Debit,@CreditDetails_DelStatus)

END
');
END;