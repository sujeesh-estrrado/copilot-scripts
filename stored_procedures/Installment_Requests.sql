IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Installment_Requests]')
    AND type = N'P'
)
BEGIN
    EXEC('
                             
CREATE procedure [dbo].[Installment_Requests]                        
@flag int =0,                                              
@RequestId bigint=0,                                              
@Types bigint=0,                                              
@StudentId bigint=0,                                              
@status bigint=0,                                              
@ApprovalBy bigint=0,                                              
@Remark varchar(500)='''',                                              
@catagory bigint=0,                                              
@SemId bigint =0,                                              
@InvoiceId bigint =0,                                              
@amount decimal(18, 2)=0,                                              
@date datetime='''',                                              
@TotalInstallment bigint =0,                                              
@InstalId bigint =0,                                             
@FinanceUser bigint =0,                                 
@billGroupID bigint =0,                       
@accountcodeid bigint =0,                       
@description varchar(500)='''',                      
@Semester bigint =0,                          
@FeeGroupID bigint =0,                        
@result int =0 output                                               
                                              
AS                                              
BEGIN                                              
                                               
 if(@flag=1)----Insert PaymentRequest------                                              
 begin                                              
  insert into [dbo].[tbl_Request_Installment] (ApprovalRequestId,[Type],[Status],Remark,Catagory,SemesterId,StudentID)                                              
  Values(@RequestId,@Types,0,@Remark,@catagory,@SemId,@StudentId)                                              
 end                                              
 if(@flag=2)----List InstallmentRequest------                                              
 begin                                              
  select Remark,SemesterId,ApprovalStatus,Semester_Name,AR.RequestId, I.Id as InstallmentID,                                  
  I.FinanceApproval,I.StudentApproval,                                  
                                                 
  CASE WHEN Catagory = 1 THEN ''Pending Payment''                                              
  WHEN Catagory = 2 THEN ''Semester''                                              
  END AS Catagory,Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS StudentName ,                                
                                
  CASE                                 
  WHEN I.[Status] = 1 THEN ''Active''                                 
   WHEN ApprovalStatus = 1  and FinanceApproval is null THEN ''Pending(Awaiting finance approval)''                                              
   WHEN ApprovalStatus = 1  and FinanceApproval =1 and StudentApproval is null THEN ''Pending(Awaiting student acceptance)''                                    
   WHEN ApprovalStatus = 1  and FinanceApproval =1 and StudentApproval =1 THEN ''Pending(Processing fee yet to pay)''                                 
   WHEN ApprovalStatus = 2 THEN ''Semester''                                 
   WHEN ApprovalStatus = 3 and FinanceApproval=2 THEN ''Finance Rejected''                             
   WHEN ApprovalStatus = 3 and StudentApproval=2 and RejectRemark is null THEN ''Student Rejected''                               
   WHEN ApprovalStatus = 3 and StudentApproval=2  and RejectRemark is not null THEN ''Student Rejected(Remark: ''+ RejectRemark+'')''                                
                                   
                                
  END AS  InstallmentStatus                                      
                      
  from tbl_Request_Installment I                                              
  left join Approval_Request AR on AR.RequestId=I.ApprovalRequestId                                              
  left join Tbl_Course_Semester c on c.Semester_Id=I.SemesterId                                              
  left join Tbl_Candidate_Personal_Det p on AR.studentid=p.Candidate_Id                                              
  where AR.StudentId=@StudentId                                  
 end                                              
                                              
                           
 if(@flag=3)----Get Installment Request by RequestID------                                              
 begin                                    
  select Remark,SemesterId,ApprovalStatus,Semester_Name,I.id as InstallmentID,I.FinanceApproval,I.StudentApproval,                                         
   CASE WHEN Catagory = 1 THEN ''Pending Payment''                                              
    WHEN Catagory = 2 THEN ''Semester''                                              
   END AS Catagory,                        
   Concat(p.Candidate_Fname,'' ''+p.Candidate_Lname) AS StudentName ,AR.studentid ,                          
   CASE                                 
    WHEN I.[Status] = 1 THEN ''Active''                                 
    WHEN ApprovalStatus = 1  and FinanceApproval is null THEN ''Pending(Awaiting finance approval)''                                              
    WHEN ApprovalStatus = 1  and FinanceApproval =1 and StudentApproval is null THEN ''Pending(Awaiting student acceptance)''                                    
    WHEN ApprovalStatus = 1  and FinanceApproval =1 and StudentApproval =1 THEN ''Pending(Processing fee yet to pay)''                                 
    WHEN ApprovalStatus = 2 THEN ''Semester''                             
    WHEN ApprovalStatus = 3 and FinanceApproval=2 THEN ''Finance Rejected''                             
    WHEN ApprovalStatus = 3 and StudentApproval=2 and RejectRemark is null THEN ''Student Rejected''                               
    WHEN ApprovalStatus = 3 and StudentApproval=2  and RejectRemark is not null THEN ''Student Rejected(Remark: ''+ RejectRemark+'')''                              
   END AS  InstallmentStatus                                 
  from tbl_Request_Installment I                                              
  left join Approval_Request AR on AR.RequestId=I.ApprovalRequestId                                              
  left join Tbl_Course_Semester c on c.Semester_Id=I.SemesterId                                              
  left join Tbl_Candidate_Personal_Det p on AR.studentid=p.Candidate_Id                                              
  where RequestId=@RequestId                                              
 end                                              
                                                
 if(@flag=4)---BiilId Insert----                                              
 begin                                              
  insert into [dbo].[tbl_Installment_Bill_Details] (InstallmentId,billId,Amount)                                              
  Values(@RequestId,@InvoiceId,@amount)                                 
                                
  update student_bill                                 
  set canadjust=0                               
                              
  where billid =@InvoiceId                               
                              
 update student_transaction                                 
  set canadjust=0                                
  where billid =@InvoiceId                               
 end                                              
                                              
 if(@flag=5)---Insert TotalInstallment----                                      
 begin                                              
  insert into [dbo].[tbl_InstallmentApproveDetails] (RequestId,StudentId,TotalInstallment,Totalamount)                                              
  Values(@RequestId,@StudentId,@TotalInstallment,@amount)                                              
  SET @result=SCOPE_IDENTITY()        
  select  @result as InstallmentId                                       
 end                                              
 if(@flag=6)---Insert Installmentdues Dates----                                              
 begin                                              
  insert into [dbo].[tbl_InstallmentSchedules] (RequestId,InstallmentId,DuesDate,DuesAmounts)                                              
  Values(@RequestId,@InstalId,@date,@amount)                                             
 end                                              
                                              
 if(@flag=7)                                              
 begin                                              
select s.RequestId,InstallmentId,CONVERT(varchar, DuesDate, 101)DuesDate,DuesAmounts,Totalamount,TotalInstallment                                              
  from tbl_InstallmentSchedules s              
  left join tbl_InstallmentApproveDetails IA on IA.Id=S.InstallmentId                                              
  where s.RequestId=@RequestId                                              
 end                                              
                          
 if(@flag=8)                                              
 begin                                              
  select name,Id from  ref_accountcode                                              
  where name=''Installment Fee''                                              
 end                               
 if(@flag=9)                                              
 begin                                  
                               
 select * from  tbl_Request_Installment                              
 where                               
 [Status]=0 and                               
 StudentId = @StudentId                               
                         
 end                                            
 if(@flag=10)----Insert PaymentRequest with finance Approval------                                              
 begin                                           
  insert into Approval_Request values (3,@StudentId,GETDATE(),1,1,@FinanceUser,GETDATE(),''Initiated by Finance'',0,''0'')                                        
  set @RequestId = SCOPE_IDENTITY()                                         
                                        
  INSERT INTO [dbo].[tbl_Request_Installment]                                          
  (StudentID,                                          
  [ApprovalRequestId],                                        
  TotalInstallment,                                
  Totalamount                                        
  ,[Type]                                          
  ,[Remark]                                          
  ,[Catagory]                                          
  ,[Status]                                          
  ,[SemesterId]                                          
  ,[FinanceApproval]                                          
  ,[FinanceApprovalBy]                                          
  ,[FinanceApprovalDate]                                          
  ,[StudentApproval]                                          
  ,[StudentApprovalDate])                                             
  Values(@StudentId, @RequestId,@TotalInstallment,@amount,@Types,@Remark,@catagory,0,@SemId,1,@FinanceUser,GETDATE(),null,null)                                          
                                          
  SELECT SCOPE_IDENTITY() AS InstallmentID                                          
                                        
                                        
  --insert into Approval_Request values (3,@StudentId,GETDATE(),1,1,1,GETDATE(),''Initiated by Finance'',0,''0'')                                        
                                          
 end                             
 if(@flag=11)                                              
 begin                                              
  select ibd.Id,ibd.InstallmentId,ibd.BillId,ibd.Amount,sbg.docno,Concat(ac.name,''-'',sb.description) as [Description],sb.datedue from  tbl_Installment_Bill_Details ibd                                        
  join student_bill sb on ibd.BillId = sb.billid                                        
  join student_bill_group sbg on sb.billgroupid = sbg.billgroupid                                        
  join ref_accountcode ac on ac.id = sb.accountcodeid                                        
  where InstallmentId = @InstalId                                        
 end                                          
 if(@flag=12)                                              
 begin                                              
  select *,                                
  CASE WHEN Catagory = 1 THEN ''Pending Payment''                                              
  WHEN Catagory = 2 THEN ''Semester''                                              
  END AS Cat,                                
  CASE                                 
  --WHEN [Status] = 0  and FinanceApproval is null THEN ''Pending, awaiting Finance approval''                                              
  WHEN [Status] = 1 THEN ''Active''                                 
  WHEN [Status] = 0  and FinanceApproval is null THEN ''Pending(Awaiting finance approval)''                            
  WHEN [Status] = 0  and FinanceApproval =1 and StudentApproval is null THEN ''Pending(Awaiting student acceptance)''                            
  WHEN [Status] = 0  and FinanceApproval =1 and StudentApproval =1 THEN ''Pending(Processing fee yet to pay)''                  
  WHEN [Status] = 2 THEN ''Semester''                                 
  WHEN [Status] = 3 and FinanceApproval=2 THEN ''Finance Rejected''                                 
  WHEN [Status] = 3 and StudentApproval=2 and RejectRemark is null THEN ''Student Rejected''                                  
  WHEN [Status] = 3 and StudentApproval=2 and RejectRemark is not null  THEN ''Student Rejected(Remark : ''+ RejectRemark+'')''                                   
  END AS  InstallmentStatus                                      
  from [tbl_Request_Installment]                                        
  where Id = @InstalId                                        
 end                                          
                                        
 if(@flag=13)                                              
 begin                                              
  select * from Tbl_Installment_Bills                                        
  where RefInstallmentId = @InstalId                                 
                                
                              
 end                                    
                                   
 if(@flag=14)  --Student Rejects Installment                                            
 begin                                              
  update tbl_Request_Installment                                   
  set [Status]  = 3, StudentApproval=2, StudentApprovalDate=GETDATE(), RejectRemark = @Remark                               
  where Id = @InstalId                                  
                                  
  update Approval_Request                                   
  set ApprovalStatus = 3                                   
  where RequestTypeId= 3                                   
  and RequestId=(select ApprovalRequestId from tbl_Request_Installment where Id = @InstalId )                                  
                                  
  update Tbl_Installment_Bills set billcancel = 1, status=3 where RefInstallmentId = @InstalId                                 
                              
  update student_bill                                 
  set canadjust=1                               
  where billid in (select billid                                 
  from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)                                
                                 
  update student_transaction                                 
  set canadjust=1                                
  where billid in (select billid                                 
from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)               
                                
                                 
                              
                              
 end                                   
 if(@flag=15)  --Finance Rejects Installment                                            
 begin                                              
  update tbl_Request_Installment                                   
  set [Status]  = 3, FinanceApproval=2, FinanceApprovalDate=GETDATE() , FinanceApprovalBy=@FinanceUser                          
  ,RejectRemark = @Remark                        
  where Id = @InstalId                                  
                                  
  update Approval_Request                                   
  set ApprovalStatus = 3                                   
  where RequestTypeId= 3                                   
  and RequestId=(select ApprovalRequestId from tbl_Request_Installment where Id = @InstalId )                                  
                                  
  update Tbl_Installment_Bills set billcancel = 1, status=3 where RefInstallmentId = @InstalId                                  
                              
  update student_bill                                 
  set canadjust=1                               
  where billid in (select billid                                 
  from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)                                
                                 
  update student_transaction                                 
  set canadjust=1                                
  where billid in (select billid                                 
  from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)                              
 end                                   
 if(@flag=16)  --Student Accepts Installment                                            
 begin                                              
  update tbl_Request_Installment                                   
  set StudentApproval=1, StudentApprovalDate=GETDATE(),ProceesingInvID = @billGroupID                                
  where Id = @InstalId                                  
 end                                 
                                 
 if(@flag=17)  --Get Pending Installment by student ID                                   
 begin                                              
  select * from  tbl_Request_Installment                                
  where [Status]=0                                 
 and ProceesingFeeStatus is null                                
 and StudentId=@StudentId                                    
 end                      
                                
 if(@flag=18)                                  
 begin                                              
  select * from  student_bill                                 
  where studentid =@StudentId                                    
 and billgroupid = @billGroupID                                
 end                                 
                                
 if(@flag=19)  --Activate Installment                                           
 begin                                              
  update tbl_Request_Installment                                   
  set [Status]  = 1, ProceesingFeeStatus =1                                 
  where Id = @InstalId                                  
                                  
                                
  update student_bill                                 
  set canadjust=0  ,                              
   datedue=(select max(datedue)                               
     from Tbl_Installment_Bills                               
     where RefInstallmentId =@InstalId)                              
                              
  where billid in (select billid                                 
  from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)                                
                                 
  update student_transaction                                 
  set canadjust=0       
  where billid in (select billid                                 
  from  tbl_Installment_Bill_Details                                
  where InstallmentId = @InstalId)                                
                                
  update Tbl_Installment_Bills                                
  set [status] = 1                                
  where [RefInstallmentId]=@InstalId                        
                      
  update Approval_Request                     
  set RefundStatus=0,                    
   ApprovalStatus = 2                     
  where  RequestTypeId=3                    
  and RequestId = (select ApprovalRequestId from tbl_Request_Installment where Id = @InstalId)                    
                    
 end                                
 if(@flag=20)     --Get Pending bills for Installment Student                              
 begin                                  
                               
select accountcodeid,bg.docno,totalamount,(totalamountpaid) as totalamountpaid,totalamountpayable,b.[description],                                   
CONCAT(name,''-'',b.[description]) as Billdescription,                                  
name as AccountCode,(B.outstandingbalance) as outstandingbalance,Bg.billgroupid,b.billid,b.studentid,CONVERT(varchar, b.dateissue, 101) as dateIssues                                        
                                         
                                         
from student_bill b                                         
left join student_bill_group bg on b.billgroupid=bg.billgroupid                                        
left join ref_accountcode A on b.accountcodeid=A.id                                        
where b.studentid=@StudentId                                         
and (B.outstandingbalance-adjustmentamount) > 0                                                   
AND (b.billcancel = 0)                                
and b.billid not in( select billid           from  tbl_Installment_Bill_Details IBD                        
join tbl_Request_Installment RI  on IBD.InstallmentId = RI.Id                              
where RI.Status=1                              
and RI.StudentID = @StudentId    )                               
                              
 end                        
 if(@flag=21)                        
 begin                        
  update Approval_Request                         
  set RefundStatus = 1,                        
  ApprovalBy=@FinanceUser ,                        
  ApprovalDate =GETDATE(),                        
  ApprovalRemark =@Remark,                        
  FlagLedger = 0                        
  where RequestId = @RequestId                        
                        
  update tbl_Request_Installment                     
  set TotalInstallment = @TotalInstallment,                        
  Totalamount =@amount,                        
  FinanceApproval = 1,                        
  FinanceApprovalBy =@FinanceUser,                        
  FinanceApprovalDate =GETDATE(),              
  SemesterId = @SemId              
  where ApprovalRequestId = @RequestId                        
                        
  select * from tbl_Request_Installment where ApprovalRequestId = @RequestId                        
                      
 end                        
 if(@flag=22)  --Insert into Tbl_Installment_Temp_Bills                    
 begin                      
  INSERT INTO [dbo].[Tbl_Installment_Temp_Bills]([RefInstallmentId],[accountcodeid],[description],[studentid],[totalamountpayable]                      
   ,[Semester],[FeeGroupID],[datedue],[datecreated],[createdby],[status])                      
  VALUES(@InstalId,@accountcodeid,@description,@studentid,@amount,@Semester,@FeeGroupID,@date,getdate(),@FinanceUser,                      
   0)                      
 end                      
                    
 if(@flag=23)                     
 begin                    
  select * from Tbl_Installment_Bills where RefInstallmentId in                    
  (select id from  tbl_Request_Installment                     
  where StudentID = @studentid                    
  and Status = 1 )                    
  and status=1                    
  and billcancel = 0                    
  order by datedue                    
 end                    
 if(@flag=24) --Update InsatllmentName by ID                    
 begin                    
                    
  update tbl_Request_Installment                    
  set InstallmentName = (select STRING_AGG(docno,''-'')                     
   from student_bill_group                    
   where billgroupid in (                    
    select billgroupid from student_bill                    
    where billid in (select BillId from tbl_Installment_Bill_Details where InstallmentId =@InstalId  )                    
    ))                    
  where Id = @InstalId                    
                
  update Tbl_Installment_Bills                
  set docno= CONCAT(RI.InstallmentName,IB.[description]),                
   [description] =''Installment''                
  from Tbl_Installment_Bills IB                
   inner join tbl_Request_Installment RI on                
   IB.RefInstallmentId = RI.Id                
  Where RI.Id = @InstalId                
 end                    
 if(@flag=25) ---Get Insatallment Summary by student id                    
 begin      
    
       
  select  RI.Id as InstallmentId, RI.StudentID,RI.InstallmentName,SUM(totalamountpayable)as totalamountpayable,                      
    SUM(totalamountpaid)as totalamountpaid, SUM(outstandingbalance)as outstandingbalance                    
  from  tbl_Request_Installment RI             
  join Tbl_Installment_Bills IB on IB.RefInstallmentId = RI.Id                    
  group by IB.RefInstallmentId,RI.InstallmentName,RI.StudentID,RI.Id,RI.Status                     
  having RI.Status =1 and RI.StudentID = @studentid            
            
           
     
 end                   
                  
 if(@flag = 26) -- Get pending instalment bills by student id                  
 begin                  
  select CONVERT(varchar, IB.datedue, 106) as datedue  ,''Insta'' as [Type],* from                   
   Tbl_Installment_Bills IB                   
   join tbl_Request_Installment RI on IB.RefInstallmentId = RI.Id                  
  where                   
   IB.studentid= @studentid                   
   and                  
   outstandingbalance>0                  
   and RI.Status = 1                  
 end              
             
 if(@flag = 27) -- Get Active and pending                  
 begin                  
             
     select * from  tbl_Request_Installment                              
   where                               
   [Status]<>3             
   and Catagory = 2            
   and SemesterId = @SemId             
   and StudentId = @StudentId                 
 end              
                   
            
            
END 
    ')
END