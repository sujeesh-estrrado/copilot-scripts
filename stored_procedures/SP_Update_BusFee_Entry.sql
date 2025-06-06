IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_BusFee_Entry]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_BusFee_Entry]                                    
(                
@Transport_Fees_Id bigint,                                
@StudenOrEmployee_Status bit,      
@StudentOrEmployee_Id bigint,    
@Department_Id bigint,    
@Total_Amount decimal(18, 2),      
@Date Datetime,    
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
@ddwhichaccount varchar(50)                  
)                                    
                                    
AS                                    
DECLARE @intErrorCode INT                                  
DECLARE @XML AS XML                                    
DECLARE @id bigint                                    
                          
                                
DECLARE @FeeCode varchar(100),                                
@InvoiceCodeStartNo varchar(100),                                
@code varchar(100),                                
@Invoice_Code_Id bigint,                                
@Invoice_Code_Prefix varchar(100),                                
@Invoice_Code_Suffix varchar(100),                                
@Invoice_Code_Old   varchar(100)                               
                                  
set @FeeCode=(Select top 1 Invoice_Code From Tbl_Transport_Fees Order By Transport_Fees_Id DESC)                                  
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                                   
set @code=ISNULL(@FeeCode+1,@InvoiceCodeStartNo)                                  
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                                   
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                               
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                               
set @Invoice_Code_Old=(Select Invoice_Code From Tbl_Transport_Fees Where Transport_Fees_Id=@Transport_Fees_Id)                                 
                                  
BEGIN TRAN                  
            
UPDATE Tbl_Transport_Fees set Delete_Status=1 Where Transport_Fees_Id=@Transport_Fees_Id             
                           
  SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                
                                   
  INSERT INTO [Tbl_Transport_Fees]      
           ([StudenOrEmployee_Status]      
   ,[StudentOrEmployee_Id]   
   ,[Department_Id]     
   ,[Invoice_Code_id]      
           ,[Invoice_Code]      
           ,[Total_Amount]      
           ,[Date])      
     VALUES      
           (      
  @StudenOrEmployee_Status      
  ,@StudentOrEmployee_Id    
  ,@Department_Id    
  ,@Invoice_Code_id      
       ,@code      
       ,@Total_Amount      
       ,@Date)                      
                                    
set @id=(SELECT @@IDENTITY)                
          
 SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM            
                              
INSERT INTO Tbl_Adjustment            
(Adjustment_Particular,            
Adjustment_Particular_Id,            
Adjustment_Invoice_Code_Id,            
Adjustment_Invoice_Code_Old,            
Adjustment_Invoice_Code_New,            
Adjustment_Date)            
VALUES(''TRANSPORT'',@id,@Invoice_Code_Id,@Invoice_Code_Old,@code,getdate())              
                                 
 SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                
            
UPDATE  Tbl_Transport_Fees_Details SET  Delete_Status=1 WHERE Transport_Fees_Id=@Transport_Fees_Id            
           
 SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                             
                                    
  
           
EXEC SP_Cancel_Payment_Details ''TRANSPORT'',@Transport_Fees_Id          
            
SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                           
               
DECLARE @ApprovalId bigint                    
                    
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
          
 SELECT @intErrorCode = @@ERROR                                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                  
                    
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''TRANSPORT'',@id,1,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address,''TRANSPORT'','''','''','''','''','''',@ddwhichaccount                      
SELECT @id            
                    
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
