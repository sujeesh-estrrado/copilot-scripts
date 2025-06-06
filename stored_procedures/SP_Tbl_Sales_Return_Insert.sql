IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Sales_Return_Insert]                        
 @Inventory_Sales_Id bigint                        
,@Sales_Return_CreatedDate datetime                        
,@Sales_Return_LastUpdatedDate datetime                        
,@Sales_Return_Comment varchar(350)                        
,@Sales_Return_Del_Status bit               
,@ProductXml xml,  
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
                       
AS                     
                 
DECLARE @intErrorCode INT                  
DECLARE @XML AS XML                    
DECLARE @id bigint                    
DECLARE @SalesReturnProductId bigint                    
DECLARE @PRODUCT_ID bigint                    
DECLARE @ReturnQuantity int                    
DECLARE @UnitId bigint                    
DECLARE @TotalPrice decimal(18,2)                    
              
                      
DECLARE @SalesReturnCode varchar(100),              
@InvoiceCodeStartNo varchar(100),              
@code varchar(100),              
@Invoice_Code_Id bigint,              
@Invoice_Code_Prefix varchar(100),               
@Invoice_Code_Suffix varchar(100)              
                    
set @SalesReturnCode=(Select top 1 Sales_Return_Code From Tbl_Sales_Return Order By Sales_Return_Id DESC)                          
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales Return'' and Invoice_Code_Current_Status=1)                           
set @code=ISNULL(@SalesReturnCode+1,@InvoiceCodeStartNo)                          
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales Return'' and Invoice_Code_Current_Status=1)                       
set @Invoice_Code_Prefix=(Select Invoice_Code_Prefix From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales Return'' and Invoice_Code_Current_Status=1)                       
set @Invoice_Code_Suffix=(Select Invoice_Code_Suffix From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Sales Return'' and Invoice_Code_Current_Status=1)                       
                      
              
BEGIN  TRAN                      
INSERT INTO [Tbl_Sales_Return]                        
           ([Sales_Return_Code]                   
           ,[Invoice_Code_Id]                       
           ,[Inventory_Sales_Id]                                   
           ,[Sales_Return_CreatedDate]                        
           ,[Sales_Return_LastUpdatedDate]                        
           ,[Sales_Return_Comment]                        
           ,[Sales_Return_Del_Status])                        
     VALUES                        
           (@code                    
           ,@Invoice_Code_Id                      
           ,@Inventory_Sales_Id                                   
           ,@Sales_Return_CreatedDate                      
           ,@Sales_Return_LastUpdatedDate                      
           ,@Sales_Return_Comment                        
           ,@Sales_Return_Del_Status)                   
                   
 set @id=(SELECT @@IDENTITY)                    
                  
 SELECT @intErrorCode = @@ERROR                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                     
                    
SELECT @XML = @ProductXml                 
              
INSERT INTO [Tbl_Sales_Return_Products]                    
           ([Sales_Return_Id]       
           ,[Sales_Prod_Return_Del_Status]                  
           ,[Inventory_Sales_Product_Id]                    
           ,[Sales_Prod_Rturn_Quantity]              
           ,[Units_id]                     
           ,[Sales_Prod_Return_price]                    
           ,[Sales_Prod_Return_TotalPrice])                    
              
SELECT @id as Sales_Return_Id,                    
0 as Sales_Prod_Return_Del_Status,           
M.Item.query(''./Inventory_Sales_Product_Id'').value(''.'',''bigint'') Inventory_Sales_Product_Id,                   
M.Item.query(''./Sales_Prod_Rturn_Quantity'').value(''.'',''int'') Sales_Prod_Rturn_Quantity,             
M.Item.query(''./Units_id'').value(''.'',''bigint'') Units_id,                            
M.Item.query(''./Sales_Prod_Return_price'').value(''.'',''decimal(18,2)'') Sales_Prod_Return_price,                  
M.Item.query(''./Sales_Prod_Return_TotalPrice'').value(''.'',''decimal(18,2)'') Sales_Prod_Return_TotalPrice                
FROM @XML.nodes(''/DocumentElement/SalesReturnProducts'')  AS M(Item)                
               
set @SalesReturnProductId=(SELECT @@IDENTITY)                    
               
SELECT @intErrorCode = @@ERROR                  
    IF (@intErrorCode <> 0) GOTO PROBLEM                 
              
SET @PRODUCT_ID= (SELECT Product_Id FROM Tbl_Inventory_Sales_Products WHERE  Inventory_Sales_Product_Id=                  
(SELECT Inventory_Sales_Product_Id FROM Tbl_Sales_Return_Products WHERE Sales_Return_Prod_Id=@SalesReturnProductId                  
))                  
              
SET @ReturnQuantity= (SELECT Sales_Prod_Rturn_Quantity FROM Tbl_Sales_Return_Products WHERE  Sales_Return_Prod_Id=@SalesReturnProductId)              
        
SET @UnitId= (SELECT Units_id FROM Tbl_Sales_Return_Products WHERE  Sales_Return_Prod_Id=@SalesReturnProductId)              
      
SET @TotalPrice= (SELECT Sales_Prod_Return_TotalPrice FROM Tbl_Sales_Return_Products WHERE  Sales_Return_Prod_Id=@SalesReturnProductId)                 
              
INSERT INTO Tbl_Product_Stocks                  
           ([InvoiceCode]                  
           ,[Product_Stock_DtTime]                             
           ,[Product_Stock_Type]                  
           ,[Product_Stock_DelStatus]             
           ,[Product_Stock_Profit_Loss]                   
           ,[Product_Current_Stock]                  
           ,[Product_Id]      
     ,[Product_Stock_Total_Price])                   
     VALUES                   
          (@Invoice_Code_Prefix+@code+@Invoice_Code_Suffix,                  
     getdate(),                  
     ''SALES RETURN'',                  
     0,              
     0,            
     @ReturnQuantity*(dbo.GetUnitConversion(@PRODUCT_ID,@UnitId)),                  
     @PRODUCT_ID,      
      @TotalPrice            
           )        
  
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
    
EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''SALES RETURN'',@id,0,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address        
            
                  
SELECT @intErrorCode = @@ERROR                    
    IF (@intErrorCode <> 0) GOTO PROBLEM                   
                  
SELECT @id                    
  COMMIT TRAN                    
                    
PROBLEM:                    
IF (@intErrorCode <> 0) BEGIN                    
PRINT ''Unexpected error occurred!''          
    ROLLBACK TRAN                   
                   
              
END
    ')
END;
