IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Payment_Approve_Particulars]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Payment_Approve_Particulars]           
@Approval_Id bigint      
AS         
Declare @Payment_Details_Id bigint       
Declare @PaymentMode int       
BEGIN        
Set @Payment_Details_Id=(Select Top 1 Payment_Details_Id From Tbl_Payment_Details Where Approval_Id=@Approval_Id)      
Set @PaymentMode=(Select Payment_Details_Mode From Tbl_Payment_Details where Payment_Details_Id=@Payment_Details_Id)      
      
 Update Tbl_Payment_Approval_List Set Approval_Status=1,        
  Approval_Date=getdate()        
Where Approval_Id=@Approval_Id       
IF (@PaymentMode=1)      
BEGIN      
INSERT INTO Tbl_Payment_Cash_Book(Payment_Details_Id,Cash_Book_Date,Cash_Book_Status)      
VALUES(@Payment_Details_Id,getdate(),0)      
END      
ELSE IF ((@PaymentMode=2)OR(@PaymentMode=3)OR(@PaymentMode=6))      
BEGIN      
INSERT INTO Tbl_Payment_Bank_Book(Payment_Details_Id,Bank_Book_Date,Bank_Book_Status)      
VALUES(@Payment_Details_Id,getdate(),0)      
END      
END
    ')
END;
