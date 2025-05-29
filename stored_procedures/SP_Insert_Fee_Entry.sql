IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Fee_Entry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Fee_Entry]                                                
(                                                
                                        
--@FeeHeadXml xml,                                
@Payment_Mode int,                                
@Payment_Due_Date datetime,                                
@Payee_Name varchar(200),                                
@Payment_No  varchar(200),                                
@Payment_Date  datetime,                                
@Payment_AccountNo varchar(150),                                
@Bank_Name varchar(100),                                
@Bank_Address varchar(300),                                
@Payment_Amount decimal(18,2),                                
@Grand_Total decimal(18,2),                    
@ddwhichaccount varchar(50),            
  @id bigint,    
@remarks varchar(50),  
@Temporary_ReceiptNo  bigint            
)                                                
                                                
AS                                                
      
   Begin                           
DECLARE @ApprovalId bigint                                
                                
INSERT INTO [Tbl_Payment_Approval_List]                                
           ([Approval_Date]                                
           ,[Approval_Due_Date]                                
           ,[Approval_Total_Amount]                                
                                        
           ,[Approval_Status]                                
           ,[Approval_Del_Status])                                
     VALUES                                
           (getdate()                                
           ,@Payment_Due_Date                                
           ,@Grand_Total                                
                                        
           ,0                                
           ,0)                                
SET @ApprovalId=(Select @@IDENTITY)                                
--  insert into dbo.Tbl_Fee_History(BalanceAmount,CashPaid,Fee_Entry_Id,Challan_Id,Approval_Id)          
--values(@Fee_Total_amount_to_be_paid-@Payment_Amount,@Payment_Amount,@id,@ch_id,@ApprovalId)                              
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''FEES'',@id,1,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address,''FEES'','''','''','''','''','''',@ddwhichaccount,@remarks,@Temporary_ReceiptNo                
     
        
                                  
SELECT @id                        
                                
               
END');
END;
