IF NOT EXISTS (

    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Expense_Head_UpdateNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Expense_Head_UpdateNew]                        
 (@Acc_Cat_Id bigint                        
,@Expense_Title varchar(100)                        
,@Expense_Description varchar(300)                        
,@Expense_Amount decimal(18,2)                        
,@Expense_Date datetime                        
                        
,@Payment_No  varchar(200)                          
,@Payment_Date  datetime                         
,@Payment_AccountNo varchar(150)                          
,@Bank_Name varchar(100)                          
,@Bank_Address varchar(300)                          
,@Payment_Amount decimal(18,2)                          
,@Payment_Mode int                          
,@Payment_Due_Date datetime                          
,@Payee_Name varchar(200)                         
,@Grand_Total decimal(18,2),            
@Expense_Id bigint      
,@Bank_Transfer_To_Which_Account  varchar(50)        
,@Bank_Transfer_From_Which_Acount varchar(50)        
,@Bank_Transfer_Payment_Mode varchar(50)        
,@Bank_Transfer_Date datetime        
,@Bank_Transfer_Remarks varchar(50),    
@ddwhichaccount varchar(50)                
)                        
AS                        
DECLARE @intErrorCode INT                        
DECLARE @ApprovalId bigint                        
DECLARE @id bigint                        
                      
DECLARE @InventoryExpenseCode varchar(100),                                    
@InvoiceCodeStartNo varchar(100),                                    
@code varchar(100),                                    
@Invoice_Code_Id bigint,                                    
@Invoice_Code_Prefix varchar(100),                                    
@Invoice_Code_Suffix varchar(100),                                 
@Acc_Cat_Name varchar(150)                    
                                      
set @InventoryExpenseCode=(Select top 1 Inventory_Invoice_code From Tbl_Expense_Head Order By Expense_Id DESC)                                  
set @InvoiceCodeStartNo=(Select top 1 Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 Order By Invoice_Code_Id DESC)                                   
set @code=ISNULL(@InventoryExpenseCode+1,@InvoiceCodeStartNo)                                  
set @Invoice_Code_Id=(Select top 1 Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 Order By Invoice_Code_Id DESC)                                   
set @Invoice_Code_Prefix=(Select top 1 Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 Order By Invoice_Code_Id DESC)                               
set @Invoice_Code_Suffix=(Select top 1 Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 Order By Invoice_Code_Id DESC)                               
                   
                      
                        
BEGIN TRAN               
              
UPDATE dbo.Tbl_Expense_Head SET Expense_Status= 1  WHERE Expense_Id=@Expense_Id             
                   
 INSERT INTO dbo.Tbl_Expense_Head                       
           (Inventory_Invoice_code,Invoice_Code_Id,Acc_Cat_Id,Expense_Title,Expense_Description,Expense_Amount,Expense_Date)                        
     VALUES                        
           (@code,@Invoice_Code_Id,@Acc_Cat_Id,@Expense_Title,@Expense_Description ,@Expense_Amount,@Expense_Date )                        
            
set @id=(SELECT @@IDENTITY)                   
            
EXEC SP_Cancel_Payment_Details ''EXPENSE'',@Expense_Id                  
SELECT @intErrorCode = @@ERROR                                      
    IF (@intErrorCode <> 0) GOTO PROBLEM                  
                        
 SELECT @intErrorCode = @@ERROR                                        
 IF (@intErrorCode <> 0) GOTO PROBLEM                        
                        
 INSERT INTO [Tbl_Payment_Approval_List]                          
       ([Approval_Date]                          
       ,[Approval_Due_Date]                          
       ,[Approval_Total_Amount]                          
       ,[Approval_Balance_Amount]                          
       ,[Approval_Status]                          
       ,[Approval_Del_Status])                          
    VALUES                          
       (getdate()                          
       ,@Payment_Due_Date                          
       ,@Grand_Total                          
       ,@Grand_Total-@Payment_Amount                          
       ,0                          
       ,0)                          
 SET @ApprovalId=(Select @@IDENTITY)                          
                       
set @Acc_Cat_Name=(SELECT Acc_Cat_Name from dbo.Tbl_Income_Expense_Category where Acc_Cat_Id=@Acc_Cat_Id)                      
                     
                  
 EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''EXPENSE'',@id,0,                          
    @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                          
    @Bank_Name,@Bank_Address ,@Acc_Cat_Name,@Bank_Transfer_To_Which_Account         
,@Bank_Transfer_From_Which_Acount         
,@Bank_Transfer_Payment_Mode         
,@Bank_Transfer_Date         
,@Bank_Transfer_Remarks ,@ddwhichaccount                             
  -- EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''EXPENSE'',@id,0,                          
  -- @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                          
  --  @Bank_Name,@Bank_Address                            
                          
   SELECT @intErrorCode = @@ERROR                                        
    IF (@intErrorCode <> 0) GOTO PROBLEM                           
                           
COMMIT TRAN                                          
                                          
PROBLEM:                                          
 IF (@intErrorCode <> 0) BEGIN                                          
 PRINT ''Unexpected error occurred!''                                          
 ROLLBACK TRAN                          
                             
END
    ')
END;
