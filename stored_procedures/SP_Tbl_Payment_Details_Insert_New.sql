IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Payment_Details_Insert_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Payment_Details_Insert_New]          
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
@PaymentBankAddress varchar(300),      
@Coupon_Code varchar(50),      
@Coupon_Amount float,      
@Expiry_Date datetime,  
  
  @Vendor_Id bigint ,  
@Bank_Transfer_To_Which_Account  varchar(50)            
,@Bank_Transfer_From_Which_Acount varchar(50)            
,@Bank_Transfer_Payment_Mode varchar(50)            
,@Bank_Transfer_Date datetime            
,@Bank_Transfer_Remarks varchar(50),        
@ddwhichaccount varchar(50)               
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
print ''a''        
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
ELSE IF (@Payment_Details_Mode=3)          
 BEGIN          
 INSERT INTO [dbo].[Tbl_Payment_DD_Register]          
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
      (@PayeeName,@Payment_Details_Amount,'' '',@ddwhichaccount,1,@PaymentDate ,@PaymentBankAddress,''DD'')          
      
set @Bank_Tran_Id  =@@IDENTITY            
      
insert into Tbl_Cheque_Bank_Transfer_Id values(@Bank_Tran_Id,@Payment_Details_Mode_Id,''DD'')         
 END       
ELSE IF (@Payment_Details_Mode=4)          
 BEGIN          
 INSERT INTO dbo.Tbl_Payment_Coupon_Register          
      (      
Coupon_Code,      
Coupon_Amount,      
Expiry_Date,      
Coupon_Status      
)          
   VALUES          
      ( @Coupon_Code ,      
@Coupon_Amount ,      
@Expiry_Date          
      ,0)          
SET @Payment_Details_Mode_Id=@@IDENTITY          
 END   
  
ELSE IF (@Payment_Details_Mode=5)              
 BEGIN              
 INSERT INTO [dbo].[Tbl_Payment_Credit_Register]              
      (Purchase_Credit_Amount             
      ,Credit_Due_Date             
      ,Vendor_Id        
   ,Purchase_Credit_DelStatus)              
   VALUES              
     (@Payment_Details_Amount        
  ,@PaymentDate        
     ,@Vendor_Id        
  ,0)             
SET @Payment_Details_Mode_Id=@@IDENTITY              
 END       
  
ELSE IF (@Payment_Details_Mode=6)                        
 BEGIN                        
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
      (@PayeeName                        
      ,@Payment_Details_Amount                        
      ,@Bank_Transfer_To_Which_Account                      
      ,@Bank_Transfer_From_Which_Acount                        
      ,@Bank_Transfer_Payment_Mode                     
      ,@Bank_Transfer_Date                       
      ,@Bank_Transfer_Remarks                     
     ,''Bank Transfer'')                        
SET @Payment_Details_Mode_Id=@@IDENTITY                        
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
           ,[Payment_Details_Del_Status])          
     VALUES          
           (@Approval_Id          
           ,@Payment_Details_Mode          
           ,@Payment_Details_Mode_Id          
           ,@Payment_Details_Particulars          
           ,@Payment_Details_Particulars_Id          
           ,@Payment_Details_Spend_Or_Receive          
           ,@Payment_Details_Amount          
           ,@PaymentDate          
           ,0)          
print ''b''        
 RETURN   @@IDENTITY       
END

');
END;
