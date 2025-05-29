IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Agent_Settlement]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Insert_Agent_Settlement]     
(             
@Amount decimal(18, 0)=0,  
@paymentmethod bigint=0,  
@remarks varchar(MAX)='''',  
@Invoice_Id bigint=0,  
@cashierid bigint=0,  
@studentid bigint=0,  
@AgentId bigint=0,  
@dateissued datetime='''',  
@bankname varchar(MAX)='''',  
@refno varchar(MAX)='''',  
@checkdate datetime='''',  
@Attachement_Path varchar(MAX)=''''  ,
@Payee_id bigint=0
)      
AS                            
                     
BEGIN              
INSERT INTO Tbl_Agent_Settlement(Amount,paymentmethod,remarks,Invoice_Id,cashierid,studentid,AgentId,dateissued,  
bankname,refno,checkdate,Attachement_Path,Created_Date,Delete_Status,Payee_id)              
VALUES(@Amount,@paymentmethod,@remarks,@Invoice_Id,@cashierid,@studentid,@AgentId,@dateissued,  
@bankname,@refno,@checkdate,@Attachement_Path,getdate(),0,@Payee_id)              
END     ');
END;
