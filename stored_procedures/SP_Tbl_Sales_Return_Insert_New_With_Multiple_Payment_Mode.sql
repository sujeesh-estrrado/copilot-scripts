IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Insert_New_With_Multiple_Payment_Mode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Tbl_Sales_Return_Insert_New_With_Multiple_Payment_Mode]                              
 @Inventory_Sales_Id bigint                              
,@Sales_Return_CreatedDate datetime                              
,@Sales_Return_LastUpdatedDate datetime                              
,@Sales_Return_Comment varchar(350)                              
,@Sales_Return_Del_Status bit                     
,@ProductXml xml,        
@PaymentXML xml,        
@Payment_Due_Date datetime,        
@Payment_Amount decimal(18,2),          
@Grand_Total decimal(18,2),      
@IsDamaged bit          
                             
AS                           
                       
DECLARE @intErrorCode INT                        
DECLARE @XML AS XML                          
DECLARE @id bigint                          
DECLARE @SalesReturnProductId bigint                          
DECLARE @PRODUCT_ID bigint                          
DECLARE @ReturnQuantity int                          
                        
DECLARE @TotalPrice decimal(18,2)                          
                    
                            
DECLARE @SalesReturnCode varchar(100),                    
@InvoiceCodeStartNo varchar(100),                    
@code varchar(100),                    
@Invoice_Code_Id bigint,                    
@Invoice_Code_Prefix varchar(100),                     
@Invoice_Code_Suffix varchar(100),@PXML XML                    
                          
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
           ,[Sales_Prod_IsDamage]                    
           ,[Sales_Prod_Return_price]                          
           ,[Sales_Prod_Return_TotalPrice])                          
                    
SELECT @id as Sales_Return_Id,                          
0 as Sales_Prod_Return_Del_Status,                 
M.Item.query(''./Inventory_Sales_Product_Id'').value(''.'',''bigint'') Inventory_Sales_Product_Id,                         
M.Item.query(''./Sales_Prod_Rturn_Quantity'').value(''.'',''int'') Sales_Prod_Rturn_Quantity,                   
M.Item.query(''./Sales_Prod_IsDamage'').value(''.'',''bit'') Sales_Prod_IsDamage,                                    
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
              
                    
            
SET @TotalPrice= (SELECT Sales_Prod_Return_TotalPrice FROM Tbl_Sales_Return_Products WHERE  Sales_Return_Prod_Id=@SalesReturnProductId)                       
                    
INSERT INTO Tbl_Product_Stocks                        
           ([InvoiceCode]                        
           ,[Product_Stock_DtTime]                                   
           ,[Product_Stock_Type]                        
           ,[Product_Stock_DelStatus]                   
           ,[Product_Stock_Profit_Loss]                         
           ,[Product_Current_Stock]                        
           ,[Product_Id]            
     ,[Product_Stock_Total_Price],      
      Product_Stock_IsDamaged)  --edit here SRJ                       
     VALUES                         
          (@Invoice_Code_Prefix+@code+@Invoice_Code_Suffix,                        
     getdate(),                        
     ''SALES RETURN'',                        
     0,                    
     0,                  
     @ReturnQuantity,                        
     @PRODUCT_ID,            
     @TotalPrice,@IsDamaged                 
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
        
--edit multiple Payment Mode start        
        
declare         
@Payment_Mode int,                
            
@Payee_Name varchar(200),                
@Payment_No  varchar(200),          
@Payment_Date  datetime,                
@Payment_AccountNo varchar(150),                
@Bank_Name varchar(100),                
@Bank_Address varchar(300),                
@PM decimal(18,2),         
@Coupon_Code varchar(50),        
@Coupon_Amount varchar(50),        
@Expiry_Date datetime ,  
@Bank_Transfer_To_Which_Account  varchar(50)              
,@Bank_Transfer_From_Which_Acount varchar(50)              
,@Bank_Transfer_Payment_Mode varchar(50)              
,@Bank_Transfer_Date datetime              
,@Bank_Transfer_Remarks varchar(50),          
@ddwhichaccount varchar(50)      ,  
@VendorId bigint        
 --assign xml data        
select @PXML=@PaymentXML          
--fetch xml data to cursor        
declare cur1 cursor local fast_forward for        
    select N.Payment_Mode, N.Payment_Amount,N.Payee_Name,N.Payment_Date,N.Payment_No,N.Payment_AccountNo,N.Bank_Name,        
N.Bank_Address,N.Coupon_Code,N.Coupon_Amount,N.Expiry_Date,N.VendorId ,N.Bank_Transfer_To_Which_Account,N.Bank_Transfer_From_Which_Acount,        
N.Bank_Transfer_Payment_Mode,N.Bank_Transfer_Date,N.Bank_Transfer_Remarks,N.ddwhichaccount from (        
        select M.Item.query(''./Payment_Mode'').value(''.'',''int'') as Payment_Mode,        
M.Item.query(''./Payment_Amount'').value(''.'',''decimal(18,2)'') as Payment_Amount,        
 M.Item.query(''./Payee_Name'').value(''.'',''varchar(200)'') as Payee_Name,        
 cast(convert(varchar(10),M.Item.query(''./Payment_Date'').value(''.'',''varchar(10)''),101) as datetime ) as Payment_Date,        
 --M.Item.query(''./Payment_Date'').value(''.'',''datetime'') as Payment_Date,        
M.Item.query(''./Payment_No'').value(''.'',''varchar(200)'') as Payment_No,        
 M.Item.query(''./Payment_AccountNo'').value(''.'',''varchar(150)'') as Payment_AccountNo,        
M.Item.query(''./Bank_Name'').value(''.'',''varchar(100)'') as Bank_Name,        
M.Item.query(''./Bank_Address'').value(''.'',''varchar(300)'') as Bank_Address,        
M.Item.query(''./Coupon_Code'').value(''.'',''varchar(50)'') as Coupon_Code,        
M.Item.query(''./Coupon_Amount'').value(''.'',''decimal(18,2)'') as Coupon_Amount,        
cast(convert(varchar(10),M.Item.query(''./Expiry_Date'').value(''.'',''varchar(10)''),101) as datetime ) as Expiry_Date ,  
 M.Item.query(''./VendorId'').value(''.'',''bigint'') as VendorId  ,        
           M.Item.query(''./Bank_Transfer_To_Which_Account'').value(''.'',''varchar(50)'') as Bank_Transfer_To_Which_Account ,        
  M.Item.query(''./Bank_Transfer_From_Which_Acount'').value(''.'',''varchar(50)'') as Bank_Transfer_From_Which_Acount ,        
  M.Item.query(''./Bank_Transfer_Payment_Mode'').value(''.'',''varchar(50)'') as Bank_Transfer_Payment_Mode ,        
   cast(convert(varchar(10),M.Item.query(''./Bank_Transfer_Date'').value(''.'',''varchar(10)''),101) as datetime ) as Bank_Transfer_Date ,        
  M.Item.query(''./Bank_Transfer_Remarks'').value(''.'',''varchar(50)'') as Bank_Transfer_Remarks ,        
  M.Item.query(''./ddwhichaccount'').value(''.'',''varchar(50)'') as ddwhichaccount        
--M.Item.query(''./Expiry_Date'').value(''.'',''datetime'') as Expiry_Date         
from @PXML.nodes(''/DocumentElement/Payment'')  AS M(Item) ) as N        
        
open cur1        
while 1 = 1        
begin        
--assign each xml row to variables        
    fetch cur1 into  @Payment_Mode,@PM ,@Payee_Name ,@Payment_Date ,@Payment_No ,@Payment_AccountNo ,  
@Bank_Name ,@Bank_Address ,@Coupon_Code ,@Coupon_Amount ,@Expiry_Date ,@VendorId,@Bank_Transfer_To_Which_Account,@Bank_Transfer_From_Which_Acount,        
@Bank_Transfer_Payment_Mode,@Bank_Transfer_Date,@Bank_Transfer_Remarks,@ddwhichaccount         
    if @@fetch_status <> 0 break        
        
    begin        
        
exec SP_Tbl_Payment_Details_Insert_New @ApprovalId,@Payment_Mode,''SALES Return'',@id,0,@PM,@Payee_Name,@Payment_Date,@Payment_No,  
@Payment_AccountNo,@Bank_Name,@Bank_Address,@Coupon_Code,@Coupon_Amount,@Expiry_Date  ,@VendorId,       
   @Bank_Transfer_To_Which_Account,@Bank_Transfer_From_Which_Acount,        
@Bank_Transfer_Payment_Mode,@Bank_Transfer_Date,@Bank_Transfer_Remarks,@ddwhichaccount      
print 4        
                
    end        
        
           
end        
close cur1        
deallocate cur1        
         
        
--End muliple payment mode         
        
        
--Single Payment Mode        
--EXEC SP_Tbl_Payment_Details_Insert @ApprovalId,@Payment_Mode,''SALES RETURN'',@id,0,@Payment_Amount,@Payee_Name,@Payment_Date,@Payment_No,@Payment_AccountNo,@Bank_Name,@Bank_Address              
--Single Payment Mode End                  
                        
SELECT @intErrorCode = @@ERROR                          
    IF (@intErrorCode <> 0) GOTO PROBLEM                         
                        
SELECT @id                          
  COMMIT TRAN                          
                          
PROBLEM:                          
IF (@intErrorCode <> 0) BEGIN                          
PRINT ''Unexpected error occurred!''                          
    ROLLBACK TRAN                         
                         
                    
END
    ');
END;
