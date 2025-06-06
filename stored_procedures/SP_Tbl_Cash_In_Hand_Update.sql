IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Cash_In_Hand_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Cash_In_Hand_Update]                              
 (                  
@Cash_Id bigint                  
,@Cash_Title varchar(100)                              
,@Cash_Description varchar(300)                              
,@Cash_Amount decimal(18,2)                              
,@Cash_Date datetime                              
                              
,@Payment_No  varchar(200)                                
,@Payment_Date  datetime                               
,@Payment_AccountNo varchar(150)                                
,@Bank_Name varchar(100)                                
,@Bank_Address varchar(300)                                
,@Payment_Amount decimal(18,2)                                
,@Payment_Mode int                                
,@Payment_Due_Date datetime                                
,@Payee_Name varchar(200)                               
,@Grand_Total decimal(18,2)                
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
                            
                            
DECLARE @InventoryCashCode varchar(100),                                          
@InvoiceCodeStartNo varchar(100),                                          
@code varchar(100),                                          
@Invoice_Code_Id bigint,                                          
@Invoice_Code_Prefix varchar(100),                                          
@Invoice_Code_Suffix varchar(100)                       
                                          
                                            
set @InventoryCashCode=(Select top 1 Cash_Invoice_Code From Tbl_Cash_In_Hand Order By Cash_Id DESC)                                            
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Cash In Hand'' and Invoice_Code_Current_Status=1)                                             
set @code=ISNULL(@InventoryCashCode+1,@InvoiceCodeStartNo)                                            
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Cash In Hand'' and Invoice_Code_Current_Status=1)                                             
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                                         
WHERE Invoice_Code_Name=''Cash In Hand'' and Invoice_Code_Current_Status=1)                                         
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                                         
WHERE Invoice_Code_Name=''Cash In Hand'' and Invoice_Code_Current_Status=1)                                         
                                         
                            
                              
BEGIN TRAN                   
                            
 UPDATE dbo.Tbl_Cash_In_Hand SET Cash_Status= 1  WHERE Cash_Id=@Cash_Id                               
                              
 INSERT INTO dbo.Tbl_Cash_In_Hand                            
           (Cash_Invoice_Code,Cash_Invoice_Code_Id,Cash_Title,Cash_Description,Cash_Amount,Cash_Date)                            
     VALUES                            
           (@code,@Invoice_Code_Id,@Cash_Title,@Cash_Description ,@Cash_Amount,@Cash_Date )                            
                              
set @id=(SELECT @@IDENTITY)                                 
                              
 EXEC SP_Cancel_Payment_Details ''Cash In Hand'',@Cash_Id                        
SELECT @intErrorCode = @@ERROR                                            
    IF (@intErrorCode <> 0) GOTO PROBLEM                   
                           
INSERT INTO Tbl_Payment_Approval_List                                  
       ([Approval_Date]                                  
       ,[Approval_Due_Date]                        
       ,[Approval_Total_Amount]                                  
       ,[Approval_Balance_Amount]                                  
       ,[Approval_Status]                                  
       ,[Approval_Del_Status])                                  
    VALUES                                  
       (getdate()                                  
       ,@Payment_Due_Date                                  
       ,@Grand_Total                               ,@Grand_Total-@Payment_Amount                                  
       ,0                                  
       ,0)                             
 SET @ApprovalId=(Select @@IDENTITY)                 
DECLARE @Payment_Details_Particulars varchar(500)              
SET @Payment_Details_Particulars=''Cash Withdrawal From A/C ''+@Bank_Transfer_From_Which_Acount              
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,''6'',''Cash In Hand'',@id,0,                                 
    @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                                  
    @Bank_Name,@Bank_Address,@Payment_Details_Particulars,                        
@Bank_Transfer_To_Which_Account                         
,@Bank_Transfer_From_Which_Acount                         
,@Bank_Transfer_Payment_Mode                         
,@Bank_Transfer_Date                         
,@Bank_Transfer_Remarks ,@ddwhichaccount                          
                        
              
                         
INSERT INTO Tbl_Payment_Approval_List                                  
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
                   
 SET @Payment_Details_Particulars=''Cash Received From A/C ''+@Bank_Transfer_From_Which_Acount              
                         
 EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,''1'',''Cash In Hand'',@id,1,                                 
    @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                                  
    @Bank_Name,@Bank_Address,@Payment_Details_Particulars,                        
@Bank_Transfer_To_Which_Account                         
,@Bank_Transfer_From_Which_Acount                         
,@Bank_Transfer_Payment_Mode                         
,@Bank_Transfer_Date                         
,@Bank_Transfer_Remarks ,@ddwhichaccount                                 
                                
   SELECT @intErrorCode = @@ERROR                                              
    IF (@intErrorCode <> 0) GOTO PROBLEM                                 
                                 
COMMIT TRAN                                                
                                                
PROBLEM:                                                
 IF (@intErrorCode <> 0) BEGIN                                                
 PRINT ''Unexpected error occurred!''         
 ROLLBACK TRAN                                
END
    ');
END
