IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Bank_Transfer_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Bank_Transfer_Insert]                      
 (                    
 @Bank_Title varchar(100)                      
,@Bank_Description varchar(300)                      
,@Bank_Amount decimal(18,2)                      
,@Bank_Date datetime                      
                      
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
,@Bank_Transfer_Remarks varchar(50)  ,            
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
                                  
                                    
set @InventoryCashCode=(Select top 1 Bank_Invoice_Code From Tbl_Bank_Transfer Order By Bank_Id DESC)                                      
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1)                                       
set @code=ISNULL(@InventoryCashCode+1,@InvoiceCodeStartNo)                                      
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1)                                       
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                                   
WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1)                                   
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                                   
WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1)                                   
                    
                      
BEGIN TRAN                      
 INSERT INTO dbo.Tbl_Bank_Transfer                      
           (Bank_Invoice_Code,Bank_Invoice_Code_Id,Bank_Title,Bank_Description,Bank_Amount,Bank_Date)                      
     VALUES                      
           (@code,@Invoice_Code_Id,@Bank_Title,@Bank_Description ,@Bank_Amount,@Bank_Date )                      
                      
set @id=(SELECT @@IDENTITY)                      
                      
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
                
  DECLARE @Payment_Details_Particulars varchar(500)    
SET @Payment_Details_Particulars=''Debited From A/C ''+@Bank_Transfer_From_Which_Acount    
              
 EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,''6'',''Bank Transfer'',@id,0,                        
    @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                        
    @Bank_Name,@Bank_Address,@Payment_Details_Particulars,              
@Bank_Transfer_To_Which_Account               
,@Bank_Transfer_From_Which_Acount               
,@Bank_Transfer_Payment_Mode               
,@Bank_Transfer_Date               
,@Bank_Transfer_Remarks ,@ddwhichaccount           
                  
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
                
 SET @Payment_Details_Particulars=''Credited To A/C ''+@Bank_Transfer_To_Which_Account    
               
 EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,''6'',''Bank Transfer'',@id,1,                        
    @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                        
    @Bank_Name,@Bank_Address,@Payment_Details_Particulars,              
@Bank_Transfer_To_Which_Account               
,@Bank_Transfer_From_Which_Acount               
,@Bank_Transfer_Payment_Mode               
,@Bank_Transfer_Date               
,@Bank_Transfer_Remarks ,@ddwhichaccount                       
                       
  -- EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''Cash'',@id,1,                        
  --  @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,                        
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
END
