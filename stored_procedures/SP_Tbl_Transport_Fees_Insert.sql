IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Transport_Fees_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Transport_Fees_Insert]       
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
AS        
    
DECLARE @id bigint                                  
    
DECLARE @FeeCode varchar(100),                              
@InvoiceCodeStartNo varchar(100),                              
@code varchar(100),                              
@Invoice_Code_Id bigint,                              
@Invoice_Code_Prefix varchar(100),                              
@Invoice_Code_Suffix varchar(100)                              
    
                                
set @FeeCode=(Select top 1 Invoice_Code From Tbl_Transport_Fees Order By Transport_Fees_Id DESC)                                  
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                                   
set @code=ISNULL(@FeeCode+1,@InvoiceCodeStartNo)                                  
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                                   
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                               
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                               
WHERE Invoice_Code_Name=''Transport'' and Invoice_Code_Current_Status=1)                               
    
BEGIN        
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
                  
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''TRANSPORT'',@id,1,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address,''TRANSPORT'','''','''','''','''','''',@ddwhichaccount            
 SELECT @id                   
    
END
    ')
END;
