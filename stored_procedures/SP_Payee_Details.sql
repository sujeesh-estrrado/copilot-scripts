IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Payee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Payee_Details]              
              
(              
@Flag bigint=0,              
@Details_Id bigint=0,          
@PayeeId bigint=0,       
@PayeeName varchar(Max)='''',       
@BankACNo  varchar(Max)='''',        
@swiftcode varchar(Max)='''',        
@BankAddress varchar(Max)='''',        
@BankTelephoneNo  varchar(Max)='''',        
@Created_By bigint=0,          
@Updated_By bigint=0         
)                            
AS                            
                                
                            
BEGIN                
if(@Flag=0)              
          
  begin            
  if exists(select Payee_Id from Tbl_Payee_Details where Payee_Id=@PayeeId and Active_Status=0)        
  begin        
  Update Tbl_Payee_Details set Active_Status=1  where Payee_Id=@PayeeId and Active_Status=0        
  Insert into Tbl_Payee_Details(PayeeName,Payee_Id,BankACNo,swiftcode,        
  BankAddress,BankTelephoneNo,Created_By,Created_Date,Delete_Status,Active_Status)              
   values(@PayeeName,@PayeeId,@BankACNo,@swiftcode,@BankAddress,@BankTelephoneNo,@Created_By,getdate(),0,0)        
  end        
  else        
  begin        
   Insert into Tbl_Payee_Details(PayeeName,Payee_Id,BankACNo,swiftcode,        
  BankAddress,BankTelephoneNo,Created_By,Created_Date,Delete_Status,Active_Status)              
   values(@PayeeName,@PayeeId,@BankACNo,@swiftcode,@BankAddress,@BankTelephoneNo,@Created_By,getdate(),0,0)           
  end        
  end              
             
              
if(@Flag=1)              
begin              
              
              
 Update dbo.Tbl_Payee_Details               
 set       
 PayeeName=@PayeeName,      
  Payee_Id=@PayeeId,          
  BankACNo=@BankACNo,          
  swiftcode=@swiftcode,          
  BankAddress=@BankAddress,          
  BankTelephoneNo=@BankTelephoneNo,          
  Updated_Date=getdate(),              
  Updated_By=@Updated_By              
 where Details_Id=@Details_Id               
                   
end                
               
if(@Flag=2)              
begin              
 select Details_Id,Payee_Id,BankAcNo,BankTelephoneNo,swiftcode,BankAddress,Created_By,Updated_By ,PayeeName            
 from Tbl_Payee_Details where Details_Id=@Details_Id              
end              
if(@Flag=3)              
begin              
 select Details_Id,Payee_Id,BankAcNo,BankTelephoneNo,swiftcode,BankAddress,Created_By,Updated_By ,PayeeName,A.Agent_Name            
 from Tbl_Payee_Details pd
 LEFT JOIN Tbl_Agent A on A.Agent_ID=pd.Payee_Id
 where Active_Status=0 and pd.Delete_Status=0 and Payee_Id=@Details_Id      
    
end     
 if(@flag=4)              
 begin              
select payee_id, PayeeName          
from Tbl_Payee_Details                                                                         
            
  where Details_Id=@Details_Id             
 end   

END 
    ');
END;
