IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Payment_Details_Insert1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[FN_SP_Tbl_Payment_Details_Insert1]          
@Approval_Id bigint,          
@Payment_Details_Mode int,          
@Payment_Details_Particulars varchar(100),          
@Payment_Details_Particulars_Id bigint,          
@Payment_Details_Spend_Or_Receive bit,          
@Payment_Details_Amount decimal(18,2),  
     
@PayeeName varchar(200),          
@PaymentDate datetime,          
@PaymentNo varchar(200),          
@PaymentAccountNo varchar(150),          
@PaymentBankName varchar(100),          
@PaymentBankAddress varchar(300)  ,
@Payment_Details_Particular_Head  varchar(50)          
AS          
DECLARE @Payment_Details_Mode_Id bigint          
BEGIN          
IF (@Payment_Details_Mode=1)          
 BEGIN          
 INSERT INTO [dbo].[FN_Tbl_Payment_Cash_Register1]          
      ([Cash_Register_Payee_Name]          
      ,[Cash_Register_Date]          
      ,[Cash_Register_Amount]          
      ,[Cash_Register_Status])          
   VALUES          
      (@PayeeName          
      ,getdate()          
      ,@Payment_Details_Amount          
      ,0)          
SET @Payment_Details_Mode_Id=@@IDENTITY          
          
 END          
ELSE IF (@Payment_Details_Mode=2)          
 BEGIN          
 INSERT INTO [dbo].[FN_Tbl_Payment_Cheque_Register1]          
           ([Cheque_Register_Payee_Name]          
           ,[Cheque_Register_Date]          
           ,[Cheque_Register_No]          
           ,[Cheque_Register_Amount]          
           ,[Cheque_Register_Account_No]          
           ,[Cheque_Register_Bank_Name]          
           ,[Cheque_Register_Bank_Address]          
           ,[Cheque_Register_Del_Status])          
     VALUES          
           (@PayeeName          
           ,@PaymentDate          
           ,@PaymentNo          
           ,@Payment_Details_Amount          
           ,@PaymentAccountNo          
           ,@PaymentBankName          
           ,@PaymentBankAddress          
           ,0)          
SET @Payment_Details_Mode_Id=@@IDENTITY          
          
 END          
ELSE IF (@Payment_Details_Mode=3)          
 BEGIN          
 INSERT INTO [dbo].[FN_Tbl_Payment_DD_Register1]          
      ([DD_Register_Payee_Name]          
      ,[DD_Register_Date]          
      ,[DD_Register_No]          
      ,[DD_Register_Amount]          
      ,[DD_Register_Account_No]          
      ,[DD_Register_Bank_Name]          
      ,[DD_Register_Bank_Address]          
      ,[DD_Register_Status])          
   VALUES          
      (@PayeeName          
      ,@PaymentDate          
      ,@PaymentNo          
      ,@Payment_Details_Amount          
      ,@PaymentAccountNo          
      ,@PaymentBankName          
      ,@PaymentBankAddress          
      ,0)          
SET @Payment_Details_Mode_Id=@@IDENTITY          
 END          
          
INSERT INTO [FN_Tbl_Payment_Details1]          
           ([Approval_Id]          
           ,[Payment_Details_Mode]          
           ,[Payment_Details_Mode_Id]          
           ,[Payment_Details_Particulars]          
           ,[Payment_Details_Particulars_Id]          
           ,[Payment_Details_Spend_Or_Receive]          
           ,[Payment_Details_Amount]          
           ,[Payment_Details_Date]          
           ,[Payment_Details_Del_Status]  
           ,Payment_Details_Particular_Head)          
     VALUES          
           (@Approval_Id          
           ,@Payment_Details_Mode          
           ,@Payment_Details_Mode_Id          
           ,@Payment_Details_Particulars          
           ,@Payment_Details_Particulars_Id          
           ,@Payment_Details_Spend_Or_Receive          
           ,@Payment_Details_Amount          
           ,@PaymentDate          
           ,0,@Payment_Details_Particular_Head)          
 RETURN   @@IDENTITY       
END



    ')
END
