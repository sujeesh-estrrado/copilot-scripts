IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Fee_Entry_Details_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Fee_Entry_Details_Insert]                                          
@Candidate_Id bigint                                          
,@InTakeId bigint                                          
,@FeeheadId bigint                                         
,@Amount decimal(18,2)                                          
,@CashPaid bigint                                          
,@BalanceAmount decimal(18,2)                                           
,@Currency bigint,                                      
@Fee_Entry_Id bigint ,                                    
@typ varchar(20),                                  
@ItemDescription varchar(100),                            
@ReceiptNo bigint,                          
@discount decimal(18,2),                        
@refund decimal(18,2),                    
@fine decimal(18,2) ,              
@mop varchar(50),      
@CollectedBy  varchar(max)                 
                                         
                                        
AS                                          
BEGIN                               
declare @feeentryId bigint   
declare @feecodeid bigint  
declare @commissionid bigint  
declare @emp_agent bigint  
set  @feecodeid=(select isnull(Fee_Settings_Id,0) as Fee_Settings_Id from dbo.Tbl_Fee_Settings F  
inner join dbo.Tbl_FeecodeStudentMap fs on fs.Feecode=F.Scheme_Code where fs.Candidate_Id=@Candidate_Id)  
 

set @emp_agent=(select  CounselorEmployee_id from dbo.Tbl_Candidate_Personal_Det where Candidate_Id=@Candidate_Id)

if(@emp_agent>0) 
begin
set  @commissionid=(select distinct isnull(Commission_Setting_Id,0) as Commission_Setting_Id from dbo.Tbl_Commission_Settings  
where IntakeId=@InTakeId and Fee_Code_Id=@feecodeid and Feehead_Id=@FeeheadId and Delete_Status=0 and EmpORAgent_Status=1) 
 end

else if(@emp_agent=0)
begin 
set  @commissionid=(select distinct isnull(Commission_Setting_Id,0) as Commission_Setting_Id from dbo.Tbl_Commission_Settings  
where IntakeId=@InTakeId and Fee_Code_Id=@feecodeid and Feehead_Id=@FeeheadId and Delete_Status=0 and EmpORAgent_Status=2)      
end

else
begin
set  @commissionid=0
end
          
                                      
INSERT INTO Tbl_Fee_Entry                                          
           (                                        
           Candidate_Id                                          
           ,IntakeId                                          
           ,FeeHeadId                                          
           ,Amount                                          
           ,Paid                                          
           ,Balance                                        
           ,Currency                                        
           ,Feeid                                     
           ,typ,Date,ReceiptNo,Discount,Refund,Itemdesc,Waived,MOP,CollectedBy                                     
           )                                          
     VALUES                                          
           (@Candidate_Id                                          
           ,@InTakeId                                          
           ,@FeeheadId                                          
           ,@Amount                                          
           ,@CashPaid   
    ,@BalanceAmount                                          
           ,@Currency                                        
           ,@Fee_Entry_Id                                      
           ,@typ,getdate(),@ReceiptNo,@discount,@refund,@ItemDescription,@fine,@mop,@CollectedBy                                  
           )                               
set  @feeentryId= scope_identity()              
            
declare @fee bigint            
set @fee=(select Paid from Tbl_Fee_Entry_Main                                   
           where Candidate_Id=@Candidate_Id            
           and IntakeId=@InTakeId                                   
           and FeeHeadId=@FeeheadId                                  
           and typ=@typ                                  
           and ItemDescription=@ItemDescription)                
            
                               
           declare @cnt bigint                                  
                                              
     set @cnt=(select count(Fee_Entry_Id) from Tbl_Fee_Entry_Main                                   
           where Candidate_Id=@Candidate_Id                                   
           and IntakeId=@InTakeId                              
           and FeeHeadId=@FeeheadId                                  
           and typ=@typ                                  
           and ItemDescription=@ItemDescription)              
                       
                                           
           if exists(select Fee_Entry_Id from Tbl_Fee_Entry_Main                                   
           where Candidate_Id=@Candidate_Id                                   
           and IntakeId=@InTakeId                                   
           and FeeHeadId=@FeeheadId                
           and typ=@typ                                  
           and ItemDescription=@ItemDescription)                            
         begin                 
                     
  if (@CashPaid>0)            
           begin                            
           update Tbl_Fee_Entry_Main                                  
           set                                   
           --Paid=@Amount-@BalanceAmount,               
           --Paid=@CashPaid,           
           Paid=@fee+@CashPaid,                             
           Balance=@BalanceAmount,  
           Fee_Code_Id=@feecodeid,  
           Commision_Settings_Id=@commissionid                      
                                  
            where Candidate_Id=@Candidate_Id                                   
           and IntakeId=@InTakeId                                   
           and FeeHeadId=@FeeheadId                                  
           and typ=@typ                                  
           and ItemDescription=@ItemDescription  
                                              
           end                              
         end                                  
         else                                  
         begin                                  
         insert into Tbl_Fee_Entry_Main                                  
         (                                        
           Candidate_Id                                          
           ,IntakeId                                          
           ,FeeHeadId                                          
           ,Amount                                          
           ,Paid                                          
           ,Balance                                        
           ,Currency                                        
           ,Feeid                                     
           ,typ                                   
           ,ItemDescription  
           ,Fee_Code_Id  
           ,Commision_Settings_Id                                      
   )          
     VALUES                                     
 (@Candidate_Id                                          
           ,@InTakeId                                          
           ,@FeeheadId                                          
           ,@Amount                     
           ,@CashPaid                                          
           ,@BalanceAmount                                          
           ,@Currency                                        
           ,@Fee_Entry_Id                                      
           ,@typ        
           ,@ItemDescription   
           ,@feecodeid  
           ,@commissionid    
           )                                   
         end                                  
          select @feeentryId                                         
END              
            
            
--select * from Tbl_Fee_Entry_Main where Candidate_Id=100            
--select * from Tbl_Fee_Entry where Candidate_Id=100

   ')
END;
