
IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAll_Agent_Invoice]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[sp_GetAll_Agent_Invoice] -- 3,''all''    
--[dbo].[sp_GetAll_Agent_Invoice]  1,3,''all'',''Malini001''    
(    
@flag bigint=0,    
@Agent_Id bigint=0,    
@ActiveStatus varchar(MAX)=''ALL'',    
@invoice varchar(MAX)=''''    
)    
AS    
    
BEGIN    
if(@flag=0)    
begin    
--declare @invoice varchar(MAX);    
    
--set @invoice=(select distinct Invoiceno from Tbl_Agent_Invoice where Agent_Id=@Agent_Id)    
    
if(@ActiveStatus=''ALL'')    
Begin     
SELECT * InTO #TEMP1 FROM    
( SELECT Base.*  FROM     
(select distinct Invoiceno,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,AI.Agent_Id,    
0 as NoofCandidates,    
CAST(coalesce((select Sum(Commission_Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id     
Inner join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id where C.Agent_ID=@Agent_Id)    
 ,0)AS DECIMAL(18,2))as CommissionAmount,    
CAST(coalesce((select Sum(Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id    
left join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id    
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId     
),0)AS DECIMAL(18,2))as Amount_Paid ,0 AS Balance,'''' as Status,Upload,0 as verification    
    
from Tbl_Agent_Invoice AI    
left join Tbl_Candidate_Personal_Det CPD on CPD.Agent_ID=AI.Agent_Id     
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=AI.AgenInvoiceId     
group by Invoiceno,Invoice_Date,AI.Agent_Id,Amount_Paid,Status,Upload)Base )A          
 SELECT     
     
Invoiceno,Invoice_Date,NoofCandidates,    
CommissionAmount,Amount_Paid ,(CommissionAmount-Amount_Paid) AS Balance,    
case when (CommissionAmount=Amount_Paid) then ''Settled''     
 when(Amount_Paid>0 and CommissionAmount>Amount_Paid)then  ''Partial''    
 when(Amount_Paid=0) then ''Not Settled''  end as Status,Upload,0 as verification    
    
 from #TEMP1 where Agent_Id=@Agent_Id    
    
end    
if(@ActiveStatus=''Settled'')    
Begin     
SELECT * InTO #TEMP2 FROM    
( SELECT Base.*  FROM     
(select distinct Invoiceno,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,AI.Agent_Id,    
0 as NoofCandidates,    
--(select count(Candidate_Id)from Tbl_Agent_Invoice where Agent_Id=@Agent_Id and Invoiceno=@invoice)as NoofCandidates,    
CAST(coalesce((select Sum(Commission_Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id     
Inner join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id where C.Agent_ID=@Agent_Id)    
 ,0)AS DECIMAL(18,2))as CommissionAmount,    
CAST(coalesce((select Sum(Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id    
left join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId    
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId     
),0)AS DECIMAL(18,2))as Amount_Paid ,0 AS Balance,'''' as Status,Upload,0 as verification    
    
from Tbl_Agent_Invoice AI    
left join Tbl_Candidate_Personal_Det CPD on CPD.Agent_ID=AI.Agent_Id     
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=AI.AgenInvoiceId     
group by Invoiceno,Invoice_Date,AI.Agent_Id,Amount_Paid,Status,Upload)Base )A         
 SELECT          
  Invoiceno,Invoice_Date, NoofCandidates,    
CommissionAmount,Amount_Paid ,(CommissionAmount-Amount_Paid) AS Balance,    
case when (CommissionAmount=Amount_Paid) then ''Settled''     
 when(Amount_Paid>0 and CommissionAmount>Amount_Paid)then  ''Partial''    
 when(Amount_Paid=0) then ''Not Settled''  end as Status,Upload,0 as verification    
    
 from #TEMP2 where (CommissionAmount=Amount_Paid) and Agent_Id=@Agent_Id    
end    
    
if(@ActiveStatus=''Not Settled'')    
Begin     
SELECT * InTO #TEMP3 FROM    
( SELECT Base.*  FROM     
(select distinct Invoiceno,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,AI.Agent_Id,    
0 as NoofCandidates,    
--(select count(Candidate_Id)from Tbl_Agent_Invoice where Agent_Id=@Agent_Id and Invoiceno=@invoice)as NoofCandidates,    
CAST(coalesce((select Sum(Commission_Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id     
Inner join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id where C.Agent_ID=@Agent_Id)    
 ,0)AS DECIMAL(18,2))as CommissionAmount,    
CAST(coalesce((select Sum(Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id    
left join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id    
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId     
),0)AS DECIMAL(18,2))as Amount_Paid ,0 AS Balance,'''' as Status,Upload,0 as verification    
    
from Tbl_Agent_Invoice AI    
left join Tbl_Candidate_Personal_Det CPD on CPD.Agent_ID=AI.Agent_Id     
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=AI.AgenInvoiceId     
group by Invoiceno,Invoice_Date,AI.Agent_Id,Amount_Paid,Status,Upload)Base )A         
 SELECT     
     
  Invoiceno,Invoice_Date, NoofCandidates,    
CommissionAmount,Amount_Paid ,(CommissionAmount-Amount_Paid) AS Balance,    
case when (CommissionAmount=Amount_Paid) then ''Settled''     
 when(Amount_Paid>0 and CommissionAmount>Amount_Paid)then  ''Partial''    
 when(Amount_Paid=0) then ''Not Settled''  end as Status,Upload,0 as verification    
 from #TEMP3 where (Amount_Paid=0) and Agent_Id=@Agent_Id    
end    
    
if(@ActiveStatus=''Partial'')    
Begin     
SELECT * InTO #TEMP4 FROM    
( SELECT Base.*  FROM     
(select distinct Invoiceno,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,AI.Agent_Id,    
0 as NoofCandidates,    
--(select count(Candidate_Id)from Tbl_Agent_Invoice where Agent_Id=@Agent_Id and Invoiceno=@invoice)as NoofCandidates,    
CAST(coalesce((select Sum(Commission_Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id     
Inner join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id where C.Agent_ID=@Agent_Id)    
 ,0)AS DECIMAL(18,2))as CommissionAmount,    
CAST(coalesce((select Sum(Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id    
left join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id    
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId     
),0)AS DECIMAL(18,2))as Amount_Paid ,0 AS Balance,'''' as Status,Upload,0 as verification    
    
from Tbl_Agent_Invoice AI    
left join Tbl_Candidate_Personal_Det CPD on CPD.Agent_ID=AI.Agent_Id     
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=AI.AgenInvoiceId     
group by Invoiceno,Invoice_Date,AI.Agent_Id,Amount_Paid,Status,Upload)Base )A          
 SELECT     
     
  Invoiceno,Invoice_Date, NoofCandidates,    
CommissionAmount,Amount_Paid ,(CommissionAmount-Amount_Paid) AS Balance,    
case when (CommissionAmount=Amount_Paid) then ''Settled''     
 when(Amount_Paid>0 and CommissionAmount>Amount_Paid)then  ''Partial''    
 when(Amount_Paid=0) then ''Not Settled''  end as Status,Upload,0 as verification    
    
 from #TEMP4 where (Amount_Paid>0 and CommissionAmount>Amount_Paid) and Agent_Id=@Agent_Id    
end    
end     
if(@flag=1)    
begin    
select count(Candidate_Id) as NoofCandidates from Tbl_Agent_Invoice where Agent_Id=@Agent_Id and Invoiceno=@invoice     
end    
if(@flag=2)    
begin    
 select * into #temp from    
 (select I.Candidate_Id,TypeOfStudent,Local_Amount,International_Amount,     
 case when TypeOfStudent=''INTERNATIONAL'' then International_Amount    
 when TypeOfStudent=''LOCAL'' then Local_Amount end as Commission_Amount    
 from Tbl_Agent_Invoice I          
left join Tbl_Candidate_Personal_Det P on P.Candidate_Id=I.Candidate_Id           
Left join tbl_New_Admission Na on Na.New_Admission_Id=P.New_Admission_Id          
left join Tbl_CommissionGroup CG on CG.ProgrammeId=NA.Department_Id and CG.FacultyId=Na.Course_Level_Id     
  and CG.IntakeId=NA.Batch_Id    
left join Tbl_CommissionMapping   CM on CM.Commission_Group_Id=CG.Commission_GroupId     
Where  I.Agent_Id=@Agent_Id and I.Invoiceno=@invoice ) b    
select CAST(coalesce(Sum(Commission_Amount),0)AS DECIMAL(18,2))as CommissionAmount    
from #temp       
end    
if(@flag=3)    
begin    
select * into #temp11 from    
 (select I.Candidate_Id,TypeOfStudent,Local_Amount,International_Amount,     
 case when TypeOfStudent=''INTERNATIONAL'' then International_Amount    
 when TypeOfStudent=''LOCAL'' then Local_Amount end as Amount    
 from Tbl_Agent_Invoice I          
left join Tbl_Candidate_Personal_Det P on P.Candidate_Id=I.Candidate_Id           
Left join tbl_New_Admission Na on Na.New_Admission_Id=P.New_Admission_Id          
left join Tbl_CommissionGroup CG on CG.ProgrammeId=NA.Department_Id and CG.FacultyId=Na.Course_Level_Id     
  and CG.IntakeId=NA.Batch_Id    
left join Tbl_CommissionMapping   CM on CM.Commission_Group_Id=CG.Commission_GroupId     
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId  
Where  I.Agent_Id=@Agent_Id and I.Invoiceno=@invoice  
) b    
select CAST(coalesce(Sum(Amount),0)AS DECIMAL(18,2))as Amount_Paid    
from #temp11    
end    
if(@flag=4)    
begin    
select (select CAST(coalesce((select Sum(Commission_Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id     
Inner join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id     
where C.Agent_Id=@Agent_Id and Invoiceno=@invoice )    
 ,0)AS DECIMAL(18,2))as CommissionAmount)-(select CAST(coalesce((select Sum(Amount)as Commission_Amount from Tbl_Commission_Settings C    
left join Tbl_Agent_Invoice I on C.Agent_id=I.Agent_Id    
left join Tbl_Candidate_Personal_Det D on D.Candidate_Id=I.Candidate_Id    
Inner join tbl_New_Admission N on D.New_Admission_Id=N.New_Admission_Id and Batch_Id=IntakeId and C.Course_Id=N.Department_Id    
Inner join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId where C.Agent_Id=@Agent_Id and Invoiceno=@invoice    
),0)AS DECIMAL(18,2))as Amount_Paid) as balance    
end    
END     
    ')
END
GO
