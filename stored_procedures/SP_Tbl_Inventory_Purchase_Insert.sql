IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Inventory_Purchase_Insert]                                    
 @Ventor_Id bigint                                    
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
,@Order_Status varchar(50),                    
@Payment_Details_Particular_Head  varchar(50)                 
,@Bank_Transfer_To_Which_Account  varchar(50)                
,@Bank_Transfer_From_Which_Acount varchar(50)                
,@Bank_Transfer_Payment_Mode varchar(50)                
,@Bank_Transfer_Date datetime                
,@Bank_Transfer_Remarks varchar(50),            
@ddwhichaccount varchar(50),  
@Challan_Prefix varchar(100),  
@Challan_No varchar(30)                               
                                 
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
                                  
--set @InventoryPurchaseCode=(Select tOP 1 Inventory_Purchase_Code From Tbl_Inventory_Purchase ORDER BY  Inventory_Purchase_iD DESC)                                  
set @InventoryPurchaseCode=(select max(cast(Inventory_Purchase_Code as int)) as  Inventory_Purchase_Code  From Tbl_Inventory_Purchase)              
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
 ,@Store_Category,@Order_Status)                                   
                                  
                                  
set @id=(SELECT @@IDENTITY)                
              
                                
 SELECT @intErrorCode = @@ERROR                                    
    IF (@intErrorCode <> 0) GOTO PROBLEM                                       
                                      
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
     ,[Inventory_Purchase_TaxAmount],Inventory_Purchase_TaxPercentage)                       
                                                   
  SELECT @id  as Inventory_Purchase_Id,                                      
                                    
  M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                                     
  M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)'') Quantity,                                   
  M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                                  
  M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                                      
  M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                                    
  M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                                  
  M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                                    
  M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount,        
M.Item.query(''./TaxPercentage'').value(''.'',''decimal(18,2)'') TaxPercentage                                    
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                                    
                                    
                                    
  SELECT @intErrorCode = @@ERROR                                    
   IF (@intErrorCode <> 0) GOTO PROBLEM                                     
                                    
  INSERT INTO [Tbl_Product_Price]                                      
     ([Product_Id]                                      
     ,Product_Price_OriginalCost                       ,Product_Price_RetailCost                    
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
                                  
                  
--  INSERT INTO dbo.Tbl_ProductPrice_Purchase                                  
--     (Inventory_Purchase_Id                    
--     ,Product_Price_Id)                    
--    VALUES  (@id,@priceID)                                  
                                  
                              
                                    
  SELECT @intErrorCode = @@ERROR                        
     IF (@intErrorCode <> 0) GOTO PROBLEM                                  
                                
       --commented out to avoid unwanted product stock entry before purchase complete entry                                  
                              
--  INSERT INTO Tbl_Product_Stocks                                        
--     ([InvoiceCode]                                        
--     ,[Product_Stock_DtTime]                                                   
--     ,[Product_Stock_Type]                                        
--     ,[Product_Stock_DelStatus]                                      
--     ,[Product_Stock_Profit_Loss]                                        
--     ,[Product_Current_Stock]                                        
--     ,[Product_Id]                             
--     ,[Product_Stock_Total_Price])                                     
--                                             
--  SELECT @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as InvoiceCode,                                        
--      getdate() as Product_Stock_DtTime,                                        
--     ''PURCHASE'' as Product_Stock_Type,                                        
--      0 as Product_Stock_DelStatus,                   
--      0 as Product_Stock_Profit_Loss,              
--      0 as  Product_Current_Stock,                              
--    -- (M.Item.query(''./Quantity'').value(''.'',''int''))as Product_Current_Stock,                                
----     (M.Item.query(''./Units_ID'').value(''.'',''bigint'')))) ,                                                 
--     (M.Item.query(''./Product_Id'').value(''.'',''bigint'')) as Product_Id ,                          
--      M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price                         
--                          
--  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                                    
--                                   
--                              
--                              
--                              
--  SELECT @intErrorCode = @@ERROR                                    
--   IF (@intErrorCode <> 0) GOTO PROBLEM                                   
                                    
                                 
 END                        
ELSE           
                    
 BEGIN                    
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
       ,TaxGpID,TaxPercentage                    
       )                                  
                                                            
    SELECT @id  as Inventory_Purchase_Id,                                      
                                      
    M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                                     
    M.Item.query(''./Quantity'').value(''.'',''decimal(18,2)'') Quantity,                                   
    M.Item.query(''./Units_ID'').value(''.'',''bigint'') Unit_ID,                                  
    M.Item.query(''./Inventory_Purchase_Prod_Price'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_Price,                                      
    M.Item.query(''./Inventory_Purchase_Prod_TotPrice'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Prod_TotPrice,                                    
    M.Item.query(''./Inventory_Purchase_Discounts'').value(''.'',''decimal(18,2)'') Inventory_Purchase_Discounts,                                  
    M.Item.query(''./Inventory_Purchase_SubTotal'').value(''.'',''decimal(18,2)'') Inventory_Purchase_SubTotal,                                    
    M.Item.query(''./TaxAmount'').value(''.'',''decimal(18,2)'') TaxAmount ,                    
    M.Item.query(''./IsDiscount'').value(''.'',''bit'') IsDiscount,                                    
    M.Item.query(''./IsTax'').value(''.'',''bit'')IsTax,                                   
    M.Item.query(''./TaxGpID'').value(''.'',''bigint'') TaxGpID  ,        
 M.Item.query(''./TaxPercentage'').value(''.'',''decimal(18,2)'') TaxPercentage                                 
    FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)                      
                             
  SELECT @intErrorCode = @@ERROR                                    
   IF (@intErrorCode <> 0) GOTO PROBLEM                                   
                                    
                     
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
                    
                    
  INSERT INTO [Tbl_Payment_Approval_List]                    
       ([Approval_Date]                    
       ,[Approval_Due_Date]                    
       ,[Approval_Total_Amount]                    
       ,[Approval_Balance_Amount] ,[Approval_Status]                    
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
   @Bank_Name,@Bank_Address ,@Payment_Details_Particular_Head,@Bank_Transfer_To_Which_Account                 
    ,@Bank_Transfer_From_Which_Acount,@Bank_Transfer_Payment_Mode,@Bank_Transfer_Date,          
@Bank_Transfer_Remarks,@ddwhichaccount,@Challan_Prefix ,@Challan_No        
                    
  SELECT @intErrorCode = @@ERROR                                  
   IF (@intErrorCode <> 0) GOTO PROBLEM                    
                
SELECT  @Id                
                     
COMMIT TRAN                                    
                                    
PROBLEM:                                    
IF (@intErrorCode <> 0) BEGIN                                    
PRINT ''Unexpected error occurred!''                                    
 ROLLBACK TRAN                         
END


    ')
END
