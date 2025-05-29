IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Inventory_Purchase_Update]            
 @Inventory_Purchase_Id bigint                   
,@Ventor_Id bigint                          
,@Inventory_Purchase_CreatedDate datetime                          
,@Inventory_Purchase_LastUpdatedDate datetime                          
,@ProductXml xml            
,@BillNo varchar(200)          
,@StoreID bigint          
,@StoreName varchar(100) --For Checking ASSET OR NOT          
,@AuthorisedPerson varchar(100)                 
        
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
        
,@Store_Category int        
,@Order_Status varchar(50)          
                       
AS                          
                        
DECLARE @intErrorCode INT                          
DECLARE @XML AS XML                       
DECLARE @id bigint ,@priceID bigint                       
                        
DECLARE @InventoryPurchaseCode varchar(100)          
  ,@InvoiceCodeStartNo varchar(100)          
  ,@code varchar(100)          
  ,@Invoice_Code_Prefix varchar(100)          
  ,@Invoice_Code_Suffix varchar(100)          
  ,@Invoice_Code_ID bigint          
  ,@ApprovalId bigint                       
                        
set @InventoryPurchaseCode=(Select tOP 1 Inventory_Purchase_Code From Tbl_Inventory_Purchase ORDER BY  Inventory_Purchase_iD DESC)                       
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code                         
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                         
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                         
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                         
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                         
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                         
                         
set @code=ISNULL(@InventoryPurchaseCode+1,@InvoiceCodeStartNo)                       
                         
set @Invoice_Code_ID =(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code                         
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                       
                        
BEGIN TRAN      
      
UPDATE Tbl_Inventory_Purchase SET Inventory_Purchase_DelStatus=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id                  
                         
                        
INSERT INTO [Tbl_Inventory_Purchase]                          
   ([Ventor_Id]                             
   ,[Inventory_Purchase_Code]                          
   ,[Inventory_Purchase_CreatedDate]                          
   ,[Inventory_Purchase_LastUpdatedDate]                          
   ,Invoice_Code_ID          
   ,BillNo           
   ,StoreID          
   ,AuthorisedPerson,Store_Category    
    
    ,Order_Status )                          
     VALUES                          
   (@Ventor_Id                           
   ,@code                                     
   ,@Inventory_Purchase_CreatedDate                          
   ,@Inventory_Purchase_LastUpdatedDate                         
   ,@Invoice_Code_ID          
   ,@BillNo          
   ,@StoreID          
   ,@AuthorisedPerson        
 ,@Store_Category    
 ,@Order_Status)                  
                        
                        
set @id=(SELECT @@IDENTITY)                            
               
 SELECT @intErrorCode = @@ERROR                          
    IF (@intErrorCode <> 0) GOTO PROBLEM           
                        
UPDATE Tbl_Inventory_Purchase_Products SET  Inventory_Purchase_Status=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id      
                  
SELECT @XML = @ProductXml                          
                         
IF (@Store_Category<>1)          
 BEGIN          
  INSERT INTO Tbl_Inventory_Purchase_Products                            
     ([Inventory_Purchase_Id]                            
     ,[Product_Id]                            
     ,[Quantity]                       
     ,Unit_ID                            
     ,[Inventory_Purchase_Prod_Price]                            
     ,[Inventory_Purchase_Prod_TotPrice]                         
     ,[Inventory_Purchase_Discounts]                            
     ,[Inventory_Purchase_SubTotal]                       
     ,[Inventory_Purchase_TaxAmount])             
                                         
  SELECT @id  as Inventory_Purchase_Id,                            
                          
  M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                           
  M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)'') Quantity,                         
  M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                       
  M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                            
  M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                          
  M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                       
  M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                          
  M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount                          
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                          
                          
                          
  SELECT @intErrorCode = @@ERROR                          
   IF (@intErrorCode <> 0) GOTO PROBLEM          
      
  UPDATE Tbl_Product_Price SET  Price_DelStatus=1 WHERE Product_Price_Id IN (SELECT Product_Price_Id FROM Tbl_ProductPrice_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id)      
  UPDATE Tbl_ProductPrice_Purchase SET Del_Status=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id      
                          
  INSERT INTO [Tbl_Product_Price]                            
     ([Product_Id]                            
     ,Product_Price_OriginalCost          
     ,Product_Price_RetailCost          
     ,Product_Price_SaleCost          
     ,Product_Price_Discount    
  ,Discount_Type         
     ,Product_Price_IsDiscount          
     ,Product_Price_IsTaxApply          
     ,Product_Price_Date          
     ,TaxGroup_Id)                          
                          
                          
  SELECT M.Item.query(''./Product_Id'').value(''.'',''bigint''),                       
     M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') ,                         
     M.Item.query(''./SalesCost'').value(''.'',''decimal(18,2)'') ,                           
     M.Item.query(''./SalesCost'').value(''.'',''decimal(18,2)''),                           
     M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') ,     
  M.Item.query(''./Discount_Type'').value(''.'',''varchar(50)'') ,                            
     M.Item.query(''./IsDiscount'').value(''.'',''bit''),                          
     M.Item.query(''./IsTax'').value(''.'',''bit''),                         
     getdate(),                          
     M.Item.query(''./TaxGpID'').value(''.'',''bigint'')                         
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                       
                          
                          
  SET @priceID=(SELECT @@IDENTITY)                           
                          
  SELECT @intErrorCode = @@ERROR                          
     IF (@intErrorCode <> 0) GOTO PROBLEM            
      
                          
                       
  INSERT INTO dbo.Tbl_ProductPrice_Purchase                       
     (Inventory_Purchase_Id          
     ,Product_Price_Id)          
    VALUES  (@id,@priceID)                       
                       
                  
                          
  SELECT @intErrorCode = @@ERROR                          
     IF (@intErrorCode <> 0) GOTO PROBLEM                       
                      
  UPDATE Tbl_Product_Stocks SET Product_Stock_DelStatus=1 WHERE InvoiceCode=        
(SELECT dbo.GetInvoiceCodeById_Code((SELECT Invoice_Code_Id FROM Tbl_Inventory_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id),(SELECT Inventory_Purchase_Code FROM Tbl_Inventory_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id))) 
   
    
               
                       
                    
  INSERT INTO Tbl_Product_Stocks                              
     ([InvoiceCode]                              
     ,[Product_Stock_DtTime]                                         
     ,[Product_Stock_Type]                              
     ,[Product_Stock_DelStatus]                            
     ,[Product_Stock_Profit_Loss]                              
     ,[Product_Current_Stock]                              
     ,[Product_Id]                   
     ,[Product_Stock_Total_Price])                            
                                   
  SELECT @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as InvoiceCode,                              
      getdate() as Product_Stock_DtTime,                              
     ''PURCHASE'' as Product_Stock_Type,                              
      0 as Product_Stock_DelStatus,         
      0 as Product_Stock_Profit_Loss,                       
     (M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)''))*(dbo.GetUnitConversion((M.Item.query(''./Product_Id'').value(''.'',''bigint'')),                      
     (M.Item.query(''./Units_ID'').value(''.'',''bigint'')))) as Product_Current_Stock,                                       
     (M.Item.query(''./Product_Id'').value(''.'',''bigint'')) as Product_Id ,                
      M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price               
                
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                          
                     
                    
                    
                    
  SELECT @intErrorCode = @@ERROR                          
   IF (@intErrorCode <> 0) GOTO PROBLEM                         
                          
                       
 END              
ELSE          
          
 BEGIN          
      
UPDATE Tbl_Asset_Purchase_Products SET  Inventory_Purchase_Status=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id      
      
      
  INSERT INTO   dbo.Tbl_Asset_Purchase_Products                      
       ([Inventory_Purchase_Id]                            
       ,[Product_Id]                            
       ,[Quantity]                       
       ,Unit_ID                            
       ,[Inventory_Purchase_Prod_Price]                            
       ,[Inventory_Purchase_Prod_TotPrice]                         
       ,[Inventory_Purchase_Discounts]                            
       ,[Inventory_Purchase_SubTotal]                       
       ,[Inventory_Purchase_TaxAmount]          
       ,IsDiscount          
       ,IsTax          
       ,TaxGpID          
       )                       
                                                  
    SELECT @id  as Inventory_Purchase_Id,                            
    M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                           
    M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)'') Quantity,                         
    M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                       
    M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                            
    M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                          
    M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                       
    M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                          
    M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount,          
    M.Item.query(''./IsDiscount'').value(''.'',''bit'') IsDiscount,                          
    M.Item.query(''./IsTax'').value(''.'',''bit'') IsTax,                         
    M.Item.query(''./TaxGpID'').value(''.'',''bigint'') TaxGpID                         
    FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)            
                   
  SELECT @intErrorCode = @@ERROR                          
   IF (@intErrorCode <> 0) GOTO PROBLEM                         
                          
   UPDATE Tbl_Asset_Stocks SET Product_Stock_DelStatus=1 WHERE InvoiceCode=        
(SELECT dbo.GetInvoiceCodeById_Code((SELECT Invoice_Code_Id FROM Tbl_Inventory_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id),(SELECT Inventory_Purchase_Code FROM Tbl_Inventory_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id)))  
  
    
               
          
 INSERT INTO  dbo.Tbl_Asset_Stocks                          
     ([InvoiceCode]                              
     ,[Product_Stock_DtTime]                                         
     ,[Product_Stock_Type]                              
     ,[Product_Stock_DelStatus]                            
     ,[Product_Stock_Profit_Loss]                              
     ,[Product_Current_Stock]                              
     ,[Product_Id]                   
     ,[Product_Stock_Total_Price])                            
                                   
  SELECT @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as InvoiceCode,                              
      getdate() as Product_Stock_DtTime,                              
     ''PURCHASE'' as Product_Stock_Type,                              
      0 as Product_Stock_DelStatus,                              
      0 as Product_Stock_Profit_Loss,      
	  
     (M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)''))*(dbo.GetUnitConversion((M.Item.query(''./Product_Id'').value(''.'',''bigint'')),                      
     (M.Item.query(''./Units_ID'').value(''.'',''bigint'')))) as Product_Current_Stock,                                       
     (M.Item.query(''./Product_Id'').value(''.'',''bigint'')) as Product_Id ,                
      M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price                     
                
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)            
                   
  SELECT @intErrorCode = @@ERROR                          
   IF (@intErrorCode <> 0) GOTO PROBLEM     
                       
 END     
    
EXEC SP_Cancel_Payment_Details ''PURCHASE'',@Inventory_Purchase_Id      
SELECT @intErrorCode = @@ERROR                          
    IF (@intErrorCode <> 0) GOTO PROBLEM       
    
         
--  DECLARE  @Payment_Details_Id bigint,@Approval_Id bigint,@Payment_Details_Mode int,@Payment_Details_Mode_Id bigint          
--SET @Payment_Details_Id=(SELECT Payment_Details_Id FROM Tbl_Payment_Details  WHERE Payment_Details_Particulars=''PURCHASE'' and Payment_Details_Particulars_Id=@Inventory_Purchase_Id)                       
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
          
  EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''PURCHASE'',@id,0,          
   @Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,          
   @Bank_Name,@Bank_Address        
        
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