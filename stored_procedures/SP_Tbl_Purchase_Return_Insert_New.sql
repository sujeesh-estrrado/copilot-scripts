IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Purchase_Return_Insert_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Purchase_Return_Insert_New]              
 @Purchase_Return_Code bigint              
,@Inventory_Purchase_Id bigint              
,@Purchase_Return_Comment varchar(350)              
,@Inventory_Purchase_Code bigint              
,@Purchase_Return_CreatedDate datetime              
,@Purchase_Return_LastUpdatedDate datetime              
,@Purchase_Return_DelStatus bit              
,@ProductXml xml        
,@PaymentXML xml           
--,@Payment_Mode int        
,@Payment_Due_Date datetime        
--,@Payee_Name varchar(200)        
--,@Payment_No  varchar(200)        
--,@Payment_Date  datetime        
--,@Payment_AccountNo varchar(150)        
--,@Bank_Name varchar(100)        
--,@Bank_Address varchar(300)        
,@Payment_Amount decimal(18,2)        
,@Grand_Total decimal(18,2)               
,@StoreName varchar(100)        
AS              
              
DECLARE @intErrorCode INT                
DECLARE @XML AS XML              
DECLARE @id bigint               
declare @product_ID bigint         
declare @PXML as XML               
            
declare @InventoryPurchaseCode varchar(100),              
@InvoiceCodeStartNo varchar(100),              
@code varchar(100),              
@Invoice_Code_Prefix varchar(100),              
@Invoice_Code_Suffix varchar(100),              
@Invoice_Code_ID bigint,        
@storeCategory int        
        
            
SET @storeCategory = (SELECT Store_Category FROM dbo.Tbl_Inventory_Purchase        
  WHERE Inventory_Purchase_Id = @Inventory_Purchase_Id )          
set @InventoryPurchaseCode=(Select tOP 1 Purchase_Return_Code From   dbo.Tbl_Purchase_Return             
ORDER BY Purchase_return_Id  DESC)              
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code               
WHERE Invoice_Code_Name=''Purchase Return'' and Invoice_Code_Current_Status=1)               
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code               
WHERE Invoice_Code_Name=''Purchase Return'' and Invoice_Code_Current_Status=1)               
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code               
WHERE Invoice_Code_Name=''Purchase Return'' and Invoice_Code_Current_Status=1)               
               
set @code=ISNULL(@InventoryPurchaseCode+1,@InvoiceCodeStartNo)              
               
set @Invoice_Code_ID =(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code               
WHERE Invoice_Code_Name=''Purchase Return'' and Invoice_Code_Current_Status=1)              
            
            
BEGIN TRAN              
            
INSERT INTO [Tbl_Purchase_Return]              
           ([Purchase_Return_Code]              
           ,[Inventory_Purchase_Id]              
           ,[Purchase_Return_Comment]              
           ,[Inventory_Purchase_Code]              
           ,[Purchase_Return_CreatedDate]              
           ,Purchase_Return_LastUpdatedDate              
           ,[Purchase_Return_DelStatus]      
     ,Invoice_Code_Id            
           )              
     VALUES              
           (@Purchase_Return_Code              
           ,@Inventory_Purchase_Id              
           ,@Purchase_Return_Comment              
           ,@Inventory_Purchase_Code              
           ,@Purchase_Return_CreatedDate              
           ,@Purchase_Return_LastUpdatedDate              
           ,@Purchase_Return_DelStatus,            
           @Invoice_Code_ID)              
              
set @id=(SELECT @@IDENTITY)                  
            
              
              
 SELECT @intErrorCode = @@ERROR                
    IF (@intErrorCode <> 0) GOTO PROBLEM                   
                  
SELECT @XML = @ProductXml                
              
              
INSERT INTO dbo.Tbl_Purchase_Return_Products              
              
  (Purchase_return_Id ,Inventory_Purchase_Prod_Id              
   ,[Product_Id]             
   ,Return_Product_Quantity              
   ,Return_Product_Price                 
   ,Return_Product_TotalPrice,UnitID            
)              
                             
      
SELECT @id as Purchase_return_Id,                 
--added Inv Pur.ProdId    
M.Item.query(''./Inventory_Purchase_Prod_Id'').value(''.'',''bigint'') Inventory_Purchase_Prod_Id,     
                
M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id,                 
M.Item.query(''./Return_Product_Quantity'').value(''.'',''int'') Return_Product_Quantity,               
M.Item.query(''./Return_Product_Price'').value(''.'',''decimal(18,2)'') Return_Product_Price,                  
M.Item.query(''./Return_Product_TotalPrice'').value(''.'',''decimal(18,2)'') Return_Product_TotalPrice ,              
M.Item.query(''./UnitID'').value(''.'',''bigint'') UnitID              
FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)               
        
                 
 SELECT @intErrorCode = @@ERROR                
    IF (@intErrorCode <> 0) GOTO PROBLEM             
         
            
IF (@storeCategory<>1)          
  BEGIN          
  INSERT INTO Tbl_Product_Stocks                    
       ([InvoiceCode]                    
       ,[Product_Stock_DtTime]                               
       ,[Product_Stock_Type]                    
       ,[Product_Stock_DelStatus]                  
       ,[Product_Stock_Profit_Loss]                    
       ,[Product_Current_Stock]                    
       ,[Product_Id]          
       ,[Product_Stock_Total_Price])                       
                         
  SELECT @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as Invoice_Code,          
  --@Purchase_Return_Code,                    
      getdate() as Product_Stock_DtTime,                    
     ''PURCHASE RETURN'' as Product_Stock_Type,                    
      0 as Product_Stock_DelStatus,                    
      1 as Product_Stock_Profit_Loss,              
      M.Item.query(''./Return_Product_Quantity'').value(''.'',''int'')as Product_Current_Stock,                             
      M.Item.query(''./Product_Id'').value(''.'',''bigint'')as Product_Id  ,          
      M.Item.query(''./Return_Product_TotalPrice'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price           
                
  FROM @XML.nodes(''/DocumentElement/Products'')  AS M(Item)              
                
                
  SELECT @intErrorCode = @@ERROR                
   IF (@intErrorCode <> 0) GOTO PROBLEM                
 END        
ELSE        
 BEGIN        
  INSERT INTO dbo.Tbl_Asset_Stocks (        
    InvoiceCode        
   ,Product_Id        
   ,Product_Stock_DtTime        
   ,Product_Current_Stock        
   ,Product_Stock_Total_Price        
   ,Product_Stock_Type        
   ,Product_Stock_Profit_Loss        
   ,Product_Stock_DelStatus)        
           
SELECT  @Invoice_Code_Prefix+@code+@Invoice_Code_Suffix as Invoice_Code,        
 M.Item.query(''./Product_Id'').value(''.'',''bigint'') Product_Id ,        
 getdate() as Product_Stock_DtTime,          
 M.Item.query(''./Return_Product_Quantity'').value(''.'',''int'') as Product_Current_Stock,                             
 M.Item.query(''./Return_Product_TotalPrice'').value(''.'',''decimal(18,2)'') as   Product_Stock_Total_Price ,          
 ''PURCHASE RETURN'' as Product_Stock_Type,        
 1 as Product_Stock_Profit_Loss,        
0 as Product_Stock_DelStatus        
FROM @XML.nodes(''/DocumentElement/Products'') AS M(Item)       
        
SELECT @intErrorCode = @@ERROR                
   IF (@intErrorCode <> 0) GOTO PROBLEM        
 END        
        
        
        
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
      
--EXEC Tbl_Vendor_Credit_Details_Insert @Ventor_Id,@Grand_Total,@Payment_Amount,@ApprovalId,1,0,@datevalue         
      
-- Edit Here        
    DECLARE         
 @Payment_Mode int,         
 @VendorId bigint,               
 @Payee_Name varchar(200),                
 @Payment_No  varchar(200),                
 @Payment_Date  datetime,                
 @Payment_AccountNo varchar(150),                
 @Bank_Name varchar(100),                
 @Bank_Address varchar(300),               
 @PM decimal(18,2) ,      
@Bank_Transfer_To_Which_Account  varchar(50)            
,@Bank_Transfer_From_Which_Acount varchar(50)            
,@Bank_Transfer_Payment_Mode varchar(50)            
,@Bank_Transfer_Date datetime            
,@Bank_Transfer_Remarks varchar(50),        
@ddwhichaccount varchar(50)             
 --assign xml data        
 select @PXML=@PaymentXML         
--fetch xml data to cursor        
DECLARE CURSOR1 cursor local fast_forward for        
    SELECT N.Payment_Mode,        
           N.Payment_Amount,        
           N.Payee_Name,        
           N.Payment_Date,        
           N.Payment_No,        
           N.Payment_AccountNo,        
           N.Bank_Name,        
           N.Bank_Address,        
     N.VendorId ,N.Bank_Transfer_To_Which_Account,N.Bank_Transfer_From_Which_Acount,      
N.Bank_Transfer_Payment_Mode,N.Bank_Transfer_Date,N.Bank_Transfer_Remarks,N.ddwhichaccount  FROM         
     (SELECT         
  M.Item.query(''./Payment_Mode'').value(''.'',''int'') as Payment_Mode,        
  M.Item.query(''./Payment_Amount'').value(''.'',''decimal(18,2)'') as Payment_Amount,        
  M.Item.query(''./Payee_Name'').value(''.'',''varchar(200)'') as Payee_Name,        
     cast(convert(varchar(10),M.Item.query(''./Payment_Date'').value(''.'',''varchar(10)''),101) as datetime ) as Payment_Date,        
  M.Item.query(''./Payment_No'').value(''.'',''varchar(200)'') as Payment_No,        
     M.Item.query(''./Payment_AccountNo'').value(''.'',''varchar(150)'') as Payment_AccountNo,        
  M.Item.query(''./Bank_Name'').value(''.'',''varchar(100)'') as Bank_Name,        
     M.Item.query(''./Bank_Address'').value(''.'',''varchar(300)'') as Bank_Address,        
     M.Item.query(''./VendorId'').value(''.'',''bigint'') as VendorId  ,      
           M.Item.query(''./Bank_Transfer_To_Which_Account'').value(''.'',''varchar(50)'') as Bank_Transfer_To_Which_Account ,      
  M.Item.query(''./Bank_Transfer_From_Which_Acount'').value(''.'',''varchar(50)'') as Bank_Transfer_From_Which_Acount ,      
  M.Item.query(''./Bank_Transfer_Payment_Mode'').value(''.'',''varchar(50)'') as Bank_Transfer_Payment_Mode ,      
   cast(convert(varchar(10),M.Item.query(''./Bank_Transfer_Date'').value(''.'',''varchar(10)''),101) as datetime ) as Bank_Transfer_Date ,      
  M.Item.query(''./Bank_Transfer_Remarks'').value(''.'',''varchar(50)'') as Bank_Transfer_Remarks ,      
  M.Item.query(''./ddwhichaccount'').value(''.'',''varchar(50)'') as ddwhichaccount   
     FROM @PXML.nodes(''/DocumentElement/Payment'')  AS M(Item) ) as N        
        
OPEN CURSOR1        
WHILE 1 = 1        
BEGIN        
--assign each xml row to variables        
    FETCH CURSOR1 into  @Payment_Mode,@PM ,@Payee_Name ,@Payment_Date ,@Payment_No ,@Payment_AccountNo ,@Bank_Name ,@Bank_Address,@VendorId,@Bank_Transfer_To_Which_Account,@Bank_Transfer_From_Which_Acount,      
@Bank_Transfer_Payment_Mode,@Bank_Transfer_Date,@Bank_Transfer_Remarks,@ddwhichaccount           
    IF @@fetch_status <> 0 BREAK        
        
  BEGIN        
        
EXEC SP_Tbl_Payment_Details_Insert_WithCredit @ApprovalId,@Payment_Mode,''PURCHASE RETURN'',@id,0,@PM,@Payee_Name,  
@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address,@VendorId,     
   @Bank_Transfer_To_Which_Account,@Bank_Transfer_From_Which_Acount,      
@Bank_Transfer_Payment_Mode,@Bank_Transfer_Date,@Bank_Transfer_Remarks,@ddwhichaccount  
        
print 4        
                
    END        
        
           
END        
CLOSE CURSOR1        
DEALLOCATE CURSOR1         
 -- Edit Here Ends       
                       
  SELECT @id               
  SELECT @intErrorCode = @@ERROR                            
   IF (@intErrorCode <> 0) GOTO PROBLEM        
      
--Prev Code Below COmmented      
      
--EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''PURCHASE RETURN'',@id,0,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address              
                     
       
        
 COMMIT TRAN                
                
PROBLEM:                
IF (@intErrorCode <> 0) BEGIN                
    ROLLBACK TRAN                
              
END

');
END;
