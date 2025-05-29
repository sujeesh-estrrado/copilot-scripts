IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_Update_OrderStatus_WithNoStockUpdate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Inventory_Purchase_Update_OrderStatus_WithNoStockUpdate]              
 @Inventory_Purchase_Id bigint                     
,@Ventor_Id bigint                            
,@Inventory_Purchase_CreatedDate datetime                            
,@Inventory_Purchase_LastUpdatedDate datetime                            
,@ProductXml xml              
,@BillNo varchar(200)            
,@StoreID bigint            
,@StoreName varchar(100) --For Checking ASSET OR NOT            
,@AuthorisedPerson varchar(100)                   
,@PaymentXML xml        
,@Payment_Amount decimal(18,2)            
,@Payment_Due_Date datetime            
,@Grand_Total decimal(18,2)          
          
,@Store_Category int          
,@Order_Status varchar(50),      
@code varchar(100),      
@IsCompleted bit,        
@Orginal_Amount decimal(18,2),        
@Deduction decimal(18,2),        
@Final_Amount decimal(18,2)              
AS                            
                          
DECLARE @intErrorCode INT                            
DECLARE @XML AS XML                          
DECLARE @id bigint, @priceID bigint                       
DECLARE @PXML AS XML         
                      
DECLARE @InventoryPurchaseCode varchar(100)            
  ,@InvoiceCodeStartNo varchar(100)      
  ,@Invoice_Code_Prefix varchar(100)            
  ,@Invoice_Code_Suffix varchar(100)            
  ,@Invoice_Code_ID bigint            
  ,@ApprovalId bigint                          
                                  
SET @InventoryPurchaseCode=(select max(cast(Inventory_Purchase_Code as int)) as Inventory_Purchase_Code From Tbl_Inventory_Purchase)                                  
SET @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code                           
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                           
SET @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code                           
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                           
SET @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code                           
WHERE Invoice_Code_Name=''Purchase'' and Invoice_Code_Current_Status=1)                           
                                   
SET @Invoice_Code_ID =(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code                           
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
   ,AuthorisedPerson
   ,Store_Category      
   ,Order_Status
   ,Orginal_Amount
   ,Deduction
   ,Final_Amount)                            
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
   ,@Order_Status
   ,@Orginal_Amount
   ,@Deduction
   ,@Final_Amount)                           
                          
SET @id=(SELECT @@IDENTITY)        
                            
SELECT @intErrorCode = @@ERROR                            
IF (@intErrorCode <> 0) GOTO PROBLEM             
                          
UPDATE Tbl_Inventory_Purchase_Products SET Inventory_Purchase_Status=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id        
                             
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
       ,[Inventory_Purchase_TaxAmount]
       ,Inventory_Purchase_TaxPercentage)               
                                           
    SELECT @id as Inventory_Purchase_Id,                              
    M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                             
    M.Item.query(''./Quantity'').value(''.'',''int'') Quantity,                           
    M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                          
    M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                              
    M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                            
    M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                          
    M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                            
    M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount,    
    M.Item.query(''./TaxPercentage'').value(''.'',''decimal(18,2)'') TaxPercentage                              
    FROM @XML.nodes(''/DocumentElement/Products'') AS M(Item)                            
                            
    SELECT @intErrorCode = @@ERROR                            
    IF (@intErrorCode <> 0) GOTO PROBLEM            
        
    UPDATE Tbl_Product_Price SET Price_DelStatus=1 WHERE Product_Price_Id IN 
        (SELECT Product_Price_Id FROM Tbl_ProductPrice_Purchase WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id)        
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
       ,TaxGroup_Id
       ,IsCompleted
       ,Tax_Percentage
       ,Tax_Amount)                            
                            
    SELECT M.Item.query(''./Product_Id'').value(''.'',''bigint''),                          
       M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)''),                           
       M.Item.query(''./SalesCost'').value(''.'',''decimal(18,2)''),                             
       M.Item.query(''./SalesCost'').value(''.'',''decimal(18,2)''),                             
       M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)''),      
       M.Item.query(''./DiscountType'').value(''.'',''varchar(50)''),                               
       M.Item.query(''./IsDiscount'').value(''.'',''bit''),                            
       M.Item.query(''./IsTax'').value(''.'',''bit''),                           
       getdate(),                            
       M.Item.query(''./TaxGpID'').value(''.'',''bigint''),
       @IsCompleted,
       M.Item.query(''./TaxPercentage'').value(''.'',''decimal(18,2)''),        
       M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'')                               
    FROM @XML.nodes(''/DocumentElement/Products'') AS M(Item)                          
                            
    SET @priceID=(SELECT @@IDENTITY)                             
                            
    SELECT @intErrorCode = @@ERROR                            
    IF (@intErrorCode <> 0) GOTO PROBLEM              
END                
ELSE            
BEGIN        
    UPDATE Tbl_Asset_Purchase_Products SET Inventory_Purchase_Status=1 WHERE Inventory_Purchase_Id=@Inventory_Purchase_Id        
              
    INSERT INTO dbo.Tbl_Asset_Purchase_Products                         
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
       ,TaxGpID)                          
                                                    
    SELECT @id as Inventory_Purchase_Id,                              
    M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                             
    M.Item.query(''./Quantity'').value(''.'',''int'') Quantity,                           
    M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                          
    M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                              
    M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                            
    M.Item.query(''./Product_Price_Discount'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                          
    M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                             
    M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount,            
    M.Item.query(''./IsDiscount'').value(''.'',''bit'') IsDiscount,                            
    M.Item.query(''./IsTax'').value(''.'',''bit'') IsTax,                           
    M.Item.query(''./TaxGpID'').value(''.'',''bigint'') TaxGpID                           
    FROM @XML.nodes(''/DocumentElement/Products'') AS M(Item)        
            
    SELECT @intErrorCode = @@ERROR                            
    IF (@intErrorCode <> 0) GOTO PROBLEM                           
END       
      
EXEC SP_Cancel_Payment_Details ''PURCHASE'',@Inventory_Purchase_Id        
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
       ,@Final_Amount-@Payment_Amount            
       ,0            
       ,0)            
SET @ApprovalId=(Select @@IDENTITY)            
      
DECLARE       
    @Payment_Mode int,       
    @VendorId bigint,             
    @Payee_Name varchar(200),              
    @Payment_No varchar(200),              
    @Payment_Date datetime,              
    @Payment_AccountNo varchar(150),              
    @Bank_Name varchar(100),              
    @Bank_Address varchar(300),              
    @PM decimal(18,2),    
    @Bank_Transfer_To_Which_Account varchar(50),          
    @Bank_Transfer_From_Which_Acount varchar(50),          
    @Bank_Transfer_Payment_Mode varchar(50),          
    @Bank_Transfer_Date datetime,          
    @Bank_Transfer_Remarks varchar(50),      
    @ddwhichaccount varchar(50)          
      
SELECT @PXML=@PaymentXML       
      
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD FOR      
    SELECT N.Payment_Mode,      
           N.Payment_Amount,      
           N.Payee_Name,      
           N.Payment_Date,      
           N.Payment_No,      
           N.Payment_AccountNo,      
           N.Bank_Name,      
           N.Bank_Address,      
           N.VendorId,
           N.Bank_Transfer_To_Which_Account,
           N.Bank_Transfer_From_Which_Acount,    
           N.Bank_Transfer_Payment_Mode,
           N.Bank_Transfer_Date,
           N.Bank_Transfer_Remarks,
           N.ddwhichaccount 
    FROM       
        (SELECT       
            M.Item.query(''./Payment_Mode'').value(''.'',''int'') as Payment_Mode,      
            M.Item.query(''./Payment_Amount'').value(''.'',''decimal(18,2)'') as Payment_Amount,      
            M.Item.query(''./Payee_Name'').value(''.'',''varchar(200)'') as Payee_Name,      
            CAST(CONVERT(VARCHAR(10),M.Item.query(''./Payment_Date'').value(''.'',''varchar(10)''),101) AS DATETIME) as Payment_Date,      
            M.Item.query(''./Payment_No'').value(''.'',''varchar(200)'') as Payment_No,      
            M.Item.query(''./Payment_AccountNo'').value(''.'',''varchar(150)'') as Payment_AccountNo,      
            M.Item.query(''./Bank_Name'').value(''.'',''varchar(100)'') as Bank_Name,      
            M.Item.query(''./Bank_Address'').value(''.'',''varchar(300)'') as Bank_Address,      
            M.Item.query(''./VendorId'').value(''.'',''bigint'') as VendorId,       
            M.Item.query(''./Bank_Transfer_To_Which_Account'').value(''.'',''varchar(50)'') as Bank_Transfer_To_Which_Account,    
            M.Item.query(''./Bank_Transfer_From_Which_Acount'').value(''.'',''varchar(50)'') as Bank_Transfer_From_Which_Acount,    
            M.Item.query(''./Bank_Transfer_Payment_Mode'').value(''.'',''varchar(50)'') as Bank_Transfer_Payment_Mode,    
            CAST(CONVERT(VARCHAR(10),M.Item.query(''./Bank_Transfer_Date'').value(''.'',''varchar(10)''),101) AS DATETIME) as Bank_Transfer_Date,    
            M.Item.query(''./Bank_Transfer_Remarks'').value(''.'',''varchar(50)'') as Bank_Transfer_Remarks,    
            M.Item.query(''./ddwhichaccount'').value(''.'',''varchar(50)'') as ddwhichaccount     
            FROM @PXML.nodes(''/DocumentElement/Payment'') AS M(Item)) as N      
      
OPEN CURSOR1      
FETCH NEXT FROM CURSOR1 INTO 
    @Payment_Mode,
    @PM,
    @Payee_Name,
    @Payment_Date,
    @Payment_No,
    @Payment_AccountNo,
    @Bank_Name,
    @Bank_Address,
    @VendorId,
    @Bank_Transfer_To_Which_Account,
    @Bank_Transfer_From_Which_Acount,    
    @Bank_Transfer_Payment_Mode,
    @Bank_Transfer_Date,
    @Bank_Transfer_Remarks,
    @ddwhichaccount         
WHILE @@FETCH_STATUS = 0      
BEGIN      
    EXEC SP_Tbl_Payment_Details_Insert_WithCredit 
        @ApprovalId,
        @Payment_Mode,
        ''PURCHASE'',
        @id,
        0,
        @PM,
        @Payee_Name,
        @Payment_Date,
        @Payment_No,
        @Payment_AccountNo,
        @Bank_Name,
        @Bank_Address,
        @VendorId,    
        @Bank_Transfer_To_Which_Account,
        @Bank_Transfer_From_Which_Acount,    
        @Bank_Transfer_Payment_Mode,
        @Bank_Transfer_Date,
        @Bank_Transfer_Remarks,
        @ddwhichaccount         
              
    FETCH NEXT FROM CURSOR1 INTO 
        @Payment_Mode,
        @PM,
        @Payee_Name,
        @Payment_Date,
        @Payment_No,
        @Payment_AccountNo,
        @Bank_Name,
        @Bank_Address,
        @VendorId,
        @Bank_Transfer_To_Which_Account,
        @Bank_Transfer_From_Which_Acount,    
        @Bank_Transfer_Payment_Mode,
        @Bank_Transfer_Date,
        @Bank_Transfer_Remarks,
        @ddwhichaccount         
END      
CLOSE CURSOR1      
DEALLOCATE CURSOR1      
      
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