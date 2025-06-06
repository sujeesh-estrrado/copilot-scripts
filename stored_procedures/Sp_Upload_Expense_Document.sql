IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Upload_Expense_Document]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Upload_Expense_Document]   
 (  
 @Event_Id bigint,  
 @Particular varchar(50),  
 @Actual_Expense decimal(18,2),  
 @DocumentName varchar(50),  
 @Document_URL varchar(Max)  
 )  
AS  
BEGIN  
update Tbl_Particulars_Detailss set ActualExpense=@Actual_Expense,DocumentName=@DocumentName,DocumentLoc=@Document_URL where Event_ID=@Event_Id and Particulars=@Particular  
  
END 
    ')
END
