IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Inventory_Sales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Inventory_Sales]                      
(          
@Inventory_Sales_Id bigint,              
@Inventory_Customer_Id bigint,                      
@Inventory_Sales_Quote_DtTime Datetime,                      
@Inventory_Sales_Order_DtTime Datetime,                      
@Inventory_Sales_Status bit,                    
@ProductXml xml,      
@Payment_Mode int,      
@Payment_Due_Date datetime,      
@Payee_Name varchar(200),      
@Payment_No  varchar(200),      
@Payment_Date  datetime,      
@Payment_AccountNo varchar(150),      
@Bank_Name varchar(100),      
@Bank_Address varchar(300),      
@Payment_Amount decimal(18,2),      
@Grand_Total decimal(18,2)      
)                      
                      
AS                      
DECLARE @intErrorCode INT                    
DECLARE @XML AS XML                      
DECLARE @id bigint                      
DECLARE @Quantity float                      
            
                  
DECLARE @InventorySalesCode varchar(100),                  
@InvoiceCodeStartNo varchar(100),                  
@code varchar(100),                  
@Invoice_Code_Id bigint,                  
@Invoice_Code_Prefix varchar(100),                  
@Invoice_Code_Suffix varchar(100)                  
                  
                    
set @InventorySalesCode=(Select top 1 Inventory_Invoice_code From Tbl_Inventory_Sales Order By Inventory_Sales_Id DESC)                      
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' and Invoice_Code_Current_Status=1)                       
set @code=ISNULL(@InventorySalesCode+1,@InvoiceCodeStartNo)                      
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales'' and Invoice_Code_Current_Status=1)                       
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                   
WHERE Invoice_Code_Name=''Sales'' and Invoice_Code_Current_Status=1)                   
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                   
WHERE Invoice_Code_Name=''Sales'' and Invoice_Code_Current_Status=1)                   
                   
                      
BEGIN TRAN        
    
UPDATE Tbl_Inventory_Sales SET Inventory_Del_Status=1 WHERE Inventory_Sales_Id=@Inventory_Sales_Id              
                      
  INSERT INTO Tbl_Inventory_Sales                   
 (Inventory_Customer_Id,                   
  Inventory_Invoice_code,                    
     Invoice_Code_Id,                  
     Inventory_Sales_Quote_DtTime,                   
     Inventory_Sales_Order_DtTime,                      
     Inventory_Sales_Status)                      
   VALUES(                  
 @Inventory_Customer_Id,                  
 @code,                  
    @Invoice_Code_Id,                  
    @Inventory_Sales_Quote_DtTime,                  
    @Inventory_Sales_Order_DtTime,                      
    @Inventory_Sales_Status )                       
                      
set @id=(SELECT @@IDENTITY)                      
                    
 SELECT @intErrorCode = @@ERROR                    
    IF (@intErrorCode <> 0) GOTO PROBLEM         
    
UPDATE Tbl_Inventory_Sales_Products SET  Inventory_Sales_Status=1 WHERE Inventory_Sales_Id=@Inventory_Sales_Id                
                      
SELECT @XML = @ProductXml                      
INSERT INTO Tbl_Inventory_Sales_Products                      
           ([Inventory_Sales_Id]                      
           ,[Inventory_Sales_Status]                      
           ,[Product_Id]                      
           ,[Quantity]               
     ,[Units_id]                     
           ,[Inventory_Sales_TotPrice]                      
           ,[Inventory_Sales_Tax_Amount]                   
           ,[Inventory_Sales_Discount]                      
           ,[Inventory_Sales_SubTotal])                     
                                 
SELECT @id as Inventory_Sales_Id,                      
0 as Inventory_Sales_Status,      
M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                     
M.Item.query(''./Quantity'').value(''.'',''int'') Quantity,                
M.Item.query(''./Units_id'').value(''.'',''bigint'') Units_id,                          
M.Item.query(''./Inventory_Sales_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Sales_TotPrice,                    
M.Item.query(''./Inventory_Sales_Tax_Amount'').value(''.'',''decimal(18,2)'') Inventory_Sales_Tax_Amount,                  
M.Item.query(''./Inventory_Sales_Discount'').value(''.'',''decimal(18,2)'') Inventory_Sales_Discount,                    
M.Item.query(''./Inventory_Sales_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Sales_SubTotal                    
FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                    
SELECT @intErrorCode = @@ERROR                    
    IF (@intErrorCode <> 0) GOTO PROBLEM             
    
UPDATE Tbl_Product_Stocks SET Product_Stock_DelStatus=1 WHERE InvoiceCode=    
(SELECT dbo.GetInvoiceCodeById_Code((SELECT Invoice_Code_Id FROM Tbl_Inventory_Sales WHERE Inventory_Sales_Id=@Inventory_Sales_Id),(SELECT Inventory_Invoice_code FROM Tbl_Inventory_Sales WHERE Inventory_Sales_Id=@Inventory_Sales_Id)))             
INSERT INTO Tbl_Product_Stocks                  
           ([InvoiceCode]                  
           ,[Product_Stock_DtTime]                             
           ,[Product_Stock_Type]                  
           ,[Product_Stock_DelStatus]                
           ,[Product_Stock_Profit_Loss]                  
           ,[Product_Current_Stock]                  
           ,[Product_Id]        
     ,[Product_Stock_IsDamaged]        
     ,[Product_Stock_Total_Price])                     
SELECT @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as InvoiceCode,                  
       getdate() as Product_Stock_DtTime,                  
      ''SALES'' as Product_Stock_Type,                  
       0 as Product_Stock_DelStatus,                  
       1 as Product_Stock_Profit_Loss,            
      (M.Item.query(''./Quantity'').value(''.'',''int''))*(dbo.GetUnitConversion((M.Item.query(''./Product_Id'').value(''.'',''bigint'')),(M.Item.query(''./Units_id'').value(''.'',''bigint'')))) as Product_Current_Stock,                           
       M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id ,          
      (M.Item.query(''./IsDamage'').value(''.'',''bit'')) as   Product_Stock_IsDamaged,             
       M.Item.query(''./Inventory_Sales_SubTotal'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price          
FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)              
                  
SELECT @intErrorCode = @@ERROR                    
    IF (@intErrorCode <> 0) GOTO PROBLEM     
    
EXEC SP_Cancel_Payment_Details ''SALES'',@Inventory_Sales_Id    
  
--DECLARE  @Payment_Details_Id bigint,@Approval_Id bigint,@Payment_Details_Mode int,@Payment_Details_Mode_Id bigint      
--SET @Payment_Details_Id=(SELECT Payment_Details_Id FROM Tbl_Payment_Details  WHERE Payment_Details_Particulars=''SALES'' and Payment_Details_Particulars_Id=@Inventory_Sales_Id)                    
--SET @Approval_Id=(SELECT Approval_Id FROM Tbl_Payment_Details WHERE Payment_Details_Id=@Payment_Details_Id)      
--SET @Payment_Details_Mode=(SELECT Payment_Details_Mode FROM Tbl_Payment_Details  WHERE Payment_Details_Id=@Payment_Details_Id)      
--SET @Payment_Details_Mode_Id=(SELECT Payment_Details_Mode_Id FROM Tbl_Payment_Details  WHERE Payment_Details_Id=@Payment_Details_Id)      
--      
--UPDATE Tbl_Payment_Details SET Payment_Details_Del_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
--UPDATE Tbl_Payment_Approval_List SET Approval_Del_Status=1 WHERE Approval_Id=@Approval_Id       
--IF(@Payment_Details_Mode=1)      
--BEGIN      
--UPDATE Tbl_Payment_Cash_Register SET Cash_Register_Status=1 WHERE Cash_Register_Id=@Payment_Details_Mode_Id      
--UPDATE Tbl_Payment_Cash_Book SET Cash_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
--END      
--ELSE IF(@Payment_Details_Mode=2)      
--BEGIN      
--UPDATE Tbl_Payment_Cheque_Register SET Cheque_Register_Del_Status=1 WHERE Cheque_Register_Id=@Payment_Details_Mode_Id      
--UPDATE Tbl_Payment_Bank_Book SET Bank_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
--END      
--ELSE IF(@Payment_Details_Mode=3)      
--BEGIN      
--UPDATE Tbl_Payment_DD_Register SET DD_Register_Status=1 WHERE DD_Register_Id=@Payment_Details_Mode_Id      
--UPDATE Tbl_Payment_Bank_Book SET Bank_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
--END      
      
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
  
      
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''SALES'',@id,1,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address        
SELECT @id    
      
SELECT @intErrorCode = @@ERROR                    
    IF (@intErrorCode <> 0) GOTO PROBLEM       
                  
  COMMIT TRAN                    
                    
PROBLEM:                    
IF (@intErrorCode <> 0) BEGIN                    
PRINT ''Unexpected error occurred!''                    
    ROLLBACK TRAN                    
END
');
END;
