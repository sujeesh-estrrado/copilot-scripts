IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetAll_Agent_Invoice_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_GetAll_Agent_Invoice_List] --1,2,''INV120'',null      
(      
@flag bigint=0,      
@Agent_Id bigint=0,      
@Invoiceno varchar(MAX)='''',      
@Request_Status varchar(MAX)=''All''      
)      
As      
Begin      
if(@flag=0)      
begin      
if(@Request_Status=''ALL'')      
Begin      
select Distinct AI.AgenInvoiceId,Invoiceno,A.Agent_Name,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,Upload,AI.Remarks,A.Agent_Id,      
case when Approval_status=1 then ''Approved'' when Approval_status=0 then ''Rejected'' when Approval_status is null then ''Pending'' else ''Pending'' end as Approval_status,      
0.00 as Commission_Amount      
from Tbl_Agent_Invoice AI      
left join Tbl_Agent A on A.Agent_Id=AI.Agent_Id      
left join Tbl_Candidate_Personal_Det P on AI.Candidate_Id=P.Candidate_Id                                                                 
left join tbl_New_Admission NA On NA.New_Admission_Id=P.New_Admission_Id        
left join Tbl_Commission_Settings S on S.IntakeId=NA.Batch_Id and S.Course_Id=NA.Department_Id      
left join student_payment Sp on Sp.accountcodeid=S.Feehead_Id and Sp.Studentid=P.Candidate_Id     
end      
if(@Request_Status=''Approved'')      
Begin      
select Distinct AI.AgenInvoiceId,Invoiceno,A.Agent_Name,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,Upload,AI.Remarks,A.Agent_Id,      
case when Approval_status=1 then ''Approved'' when Approval_status=0 then ''Rejected'' when Approval_status is null then ''Pending'' else ''Pending'' end as Approval_status,      
0.00 as Commission_Amount      
from Tbl_Agent_Invoice AI      
left join Tbl_Agent A on A.Agent_Id=AI.Agent_Id      
left join Tbl_Candidate_Personal_Det P on AI.Candidate_Id=P.Candidate_Id                                                                 
left join tbl_New_Admission NA On NA.New_Admission_Id=P.New_Admission_Id        
left join Tbl_Commission_Settings S on S.IntakeId=NA.Batch_Id and S.Course_Id=NA.Department_Id      
left join student_payment Sp on Sp.accountcodeid=S.Feehead_Id and Sp.Studentid=P.Candidate_Id where Approval_status=1      
end      
if(@Request_Status=''Rejected'')      
Begin      
select Distinct AI.AgenInvoiceId,Invoiceno,A.Agent_Name,CONVERT(VARCHAR(10), Invoice_Date, 103)as Invoice_Date,  
case when Upload is null then ''N/A'' when Upload='''' then ''N/A'' else Upload end as Upload,AI.Remarks,A.Agent_Id,      
case when Approval_status=1 then ''Approved'' when Approval_status=0 then ''Rejected'' when Approval_status is null then ''Pending'' else ''Pending'' end as Approval_status,      
0.00 as Commission_Amount       
from Tbl_Agent_Invoice AI      
left join Tbl_Agent A on A.Agent_Id=AI.Agent_Id      
left join Tbl_Candidate_Personal_Det P on AI.Candidate_Id=P.Candidate_Id                                                                 
left join tbl_New_Admission NA On NA.New_Admission_Id=P.New_Admission_Id        
left join Tbl_Commission_Settings S on S.IntakeId=NA.Batch_Id and S.Course_Id=NA.Department_Id      
left join student_payment Sp on Sp.accountcodeid=S.Feehead_Id and Sp.Studentid=P.Candidate_Id where Approval_status=0      
end      
end      
if(@flag=1)      
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
Where  I.Agent_Id=@Agent_Id and I.Invoiceno=@Invoiceno ) b
select CAST(coalesce(Sum(Commission_Amount),0)AS DECIMAL(18,2))as Commission_Amount
from #temp 
  
      
end      
End  
    ');
END
GO