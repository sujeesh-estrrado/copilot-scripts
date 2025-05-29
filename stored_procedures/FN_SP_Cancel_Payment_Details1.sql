IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Cancel_Payment_Details1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
create procedure [dbo].[FN_SP_Cancel_Payment_Details1]    
@ParticularType varchar(100),    
@ParticularId bigint    
AS    
BEGIN    
    
DECLARE  @rc int,@Payment_Details_Id bigint,@Approval_Id bigint,@Payment_Details_Mode int,@Payment_Details_Mode_Id bigint      
    
SET @rc = (Select count(Payment_Details_Id) From FN_Tbl_Payment_Details1  WHERE Payment_Details_Particulars=@ParticularType and Payment_Details_Particulars_Id=@ParticularId);    
    
SELECT * INTO #I FROM FN_Tbl_Payment_Details1  WHERE Payment_Details_Particulars=@ParticularType and Payment_Details_Particulars_Id=@ParticularId ORDER BY Payment_Details_Id;    
    
WHILE @rc > 0    
BEGIN    
  
 SET @Payment_Details_Id=(SELECT TOP (1) Payment_Details_Id FROM #I  ORDER BY Payment_Details_Id)     
 SET @Approval_Id=(SELECT TOP (1) Approval_Id FROM #I  ORDER BY Payment_Details_Id)      
 SET @Payment_Details_Mode=(SELECT TOP (1) Payment_Details_Mode FROM #I  ORDER BY Payment_Details_Id)      
 SET @Payment_Details_Mode_Id=(SELECT TOP (1) Payment_Details_Mode_Id FROM #I  ORDER BY Payment_Details_Id)      
       
 UPDATE FN_Tbl_Payment_Details1 SET Payment_Details_Del_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
 UPDATE FN_Tbl_Payment_Approval_List1 SET Approval_Del_Status=1 WHERE Approval_Id=@Approval_Id       
 IF(@Payment_Details_Mode=1)      
  BEGIN      
  UPDATE FN_Tbl_Payment_Cash_Register1 SET Cash_Register_Status=1 WHERE Cash_Register_Id=@Payment_Details_Mode_Id      
  UPDATE FN_Tbl_Payment_Cash_Book1 SET Cash_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
  END      
 ELSE IF(@Payment_Details_Mode=2)      
  BEGIN      
  UPDATE FN_Tbl_Payment_Cheque_Register1 SET Cheque_Register_Del_Status=1 WHERE Cheque_Register_Id=@Payment_Details_Mode_Id      
  UPDATE FN_Tbl_Payment_Bank_Book1 SET Bank_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
  END      
 ELSE IF(@Payment_Details_Mode=3)      
  BEGIN      
  UPDATE FN_Tbl_Payment_DD_Register1 SET DD_Register_Status=1 WHERE DD_Register_Id=@Payment_Details_Mode_Id      
  UPDATE FN_Tbl_Payment_Bank_Book1 SET Bank_Book_Status=1 WHERE Payment_Details_Id=@Payment_Details_Id      
     END    
 Delete top(1) From #I     
 Set @rc=@rc-1       
END      
DROP TABLE  #I  
END

    ')
END
