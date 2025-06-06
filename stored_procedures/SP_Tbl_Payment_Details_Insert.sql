IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Payment_Details_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Payment_Details_Insert]                                      
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
,@Bank_Transfer_To_Which_Account  varchar(50)                        
,@Bank_Transfer_From_Which_Acount varchar(50)                        
,@Bank_Transfer_Payment_Mode varchar(50)                        
,@Bank_Transfer_Date datetime                        
,@Bank_Transfer_Remarks varchar(50),                    
@ddwhichaccount varchar(50),          
@remarks varchar(50),      
@Temporary_ReceiptNo bigint      
                          
AS                                      
DECLARE @Payment_Details_Mode_Id bigint                        
declare @Bank_Tran_Id bigint                    
                                  
BEGIN                                      
IF (@Payment_Details_Mode=1)                                      
 BEGIN                                      
 INSERT INTO [dbo].[Tbl_Payment_Cash_Register]                                      
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
 INSERT INTO [dbo].[Tbl_Payment_Cheque_Register]                                      
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
                    
INSERT INTO [dbo].[Tbl_Payment_Bank_Transfer]                             
      (Bank_Transfer_Payee_Name                                      
      ,Bank_Transfer_Amount               
      ,Bank_Transfer_To_Which_Account                                      
      ,Bank_Transfer_From_Which_Acount                                      
      ,Bank_Transfer_Payment_Mode                                      
      ,Bank_Transfer_Date                     
      ,Bank_Transfer_Remarks                                      
      ,Bank_Transfer_Type)                                      
   VALUES                                      
      (@PayeeName,@Payment_Details_Amount,'' '',@ddwhichaccount,1,@PaymentDate ,@PaymentBankAddress,''Cheque'')                    
                       
set @Bank_Tran_Id  =@@IDENTITY                          
                    
insert into Tbl_Cheque_Bank_Transfer_Id values(@Bank_Tran_Id,@Payment_Details_Mode_Id,''Cheque'')                                 
 END                                      
  else if(@Payment_Details_Mode=8)          
begin          
set @Payment_Details_Mode_Id=0           
end                                
             
                   
DECLARE @TEMP_PAYMODE BIGINT        
        
IF(@Payment_Details_Mode_Id IS NULL OR  @Payment_Details_Mode_Id='''')        
BEGIN              
SET @TEMP_PAYMODE=0         
END        
ELSE        
BEGIN        
SET @TEMP_PAYMODE=@Payment_Details_Mode_Id        
           
END                         
                                      
INSERT INTO [Tbl_Payment_Details]                                      
           ([Approval_Id]                                      
           ,[Payment_Details_Mode]                                      
           ,[Payment_Details_Mode_Id]                                      
           ,[Payment_Details_Particulars]                                      
           ,[Payment_Details_Particulars_Id]                                      
           ,[Payment_Details_Spend_Or_Receive]                                      
           ,[Payment_Details_Amount]                                      
           ,[Payment_Details_Date]                                      
           ,[Payment_Details_Del_Status]                              
           ,Payment_Details_Particular_Head,Remarks      
           ,Temporary_ReceiptNo                  
  )                                      
     VALUES                                      
           (@Approval_Id                                      
           ,@Payment_Details_Mode                                   
           ,@TEMP_PAYMODE                                      
           ,@Payment_Details_Particulars                                      
           ,@Payment_Details_Particulars_Id                                      
           ,@Payment_Details_Spend_Or_Receive                                      
           ,@Payment_Details_Amount                                      
           ,@PaymentDate                                      
           ,0,@Payment_Details_Particular_Head,@remarks,@Temporary_ReceiptNo)                                      
 RETURN   @@IDENTITY                                   
END  
    ')
END
