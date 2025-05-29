IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Agent_Commission_ByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_Get_Agent_Commission_ByID] --15
(@flag bigint=0,
@Agent_ID bigint=0)

As
Begin
if(@flag=0)
begin
SELECT * InTO #TEMP1 FROM
( SELECT ROW_NUMBER() OVER (ORDER BY Commission_Setting_Id desc) AS SlNo,Base.*  FROM 
(select distinct [Commission_Setting_Id],[Candidate_Fname]+'' ''+[Candidate_Lname] As Student_name,
groupname as Feecode,name as Fee_Head_Name,
[Commission_Amount],[Agent_Name] as Name,Isnull(sum(Amount),0) as totalamountpaid,
0 as balance,[EmpORAgent_Status] 
from Tbl_Commission_Settings C
inner join [dbo].[Tbl_Candidate_Personal_Det] on C.[Agent_ID]=[Tbl_Candidate_Personal_Det].[Agent_ID]
inner join [dbo].[Tbl_Agent] on [dbo].[Tbl_Agent].[Agent_ID]=Tbl_Candidate_Personal_Det.[Agent_ID]
left join ref_accountcode AC on C.Feehead_Id=AC.id
left join fee_group G on C.Fee_Code_Id=G.groupid
inner join Tbl_Course_Batch_Duration BD on BD.Batch_Id=C.IntakeId
left join Tbl_Agent_Invoice I on I.Agent_Id=C.[Agent_ID] and I.Candidate_Id=[Tbl_Candidate_Personal_Det].[Candidate_Id]
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId 
where  Tbl_Agent.Agent_ID=@Agent_ID --and balance=0
group by Commission_Setting_Id,AgenInvoiceId,[Candidate_Fname],[Candidate_Lname],groupname,name,[Commission_Amount],[Agent_Name],EmpORAgent_Status

)Base )A      
 SELECT SlNo,[Commission_Setting_Id],Student_name,
Feecode,Fee_Head_Name,
Commission_Amount, Name,totalamountpaid,
(Commission_Amount-totalamountpaid) as balance,
EmpORAgent_Status from #TEMP1
end

if(@flag=1)
begin
SELECT * InTO #TEMP2 FROM
( SELECT ROW_NUMBER() OVER (ORDER BY Commission_Setting_Id desc) AS SlNo,Base.*  FROM 
(select distinct [Commission_Setting_Id],[Candidate_Fname]+'' ''+[Candidate_Lname] As Student_name,
groupname as Feecode,name as Fee_Head_Name,NA.Batch_Id,C.IntakeId,
[Commission_Amount],[Agent_Name] as Name,Isnull(sum(Amount),0) as totalamountpaid,
0 as balance,[EmpORAgent_Status] 
from Tbl_Commission_Settings C
inner join [dbo].[Tbl_Candidate_Personal_Det] on C.[Agent_ID]=[Tbl_Candidate_Personal_Det].[Agent_ID]
inner join Tbl_New_Admission NA on NA.New_Admission_Id=[Tbl_Candidate_Personal_Det].New_Admission_Id and NA.Batch_Id=C.IntakeId
inner join [dbo].[Tbl_Agent] on [dbo].[Tbl_Agent].[Agent_ID]=Tbl_Candidate_Personal_Det.[Agent_ID]
left join ref_accountcode AC on C.Feehead_Id=AC.id
left join fee_group G on C.Fee_Code_Id=G.groupid
inner join Tbl_Course_Batch_Duration BD on BD.Batch_Id=C.IntakeId
left join Tbl_Agent_Invoice I on I.Agent_Id=C.[Agent_ID] and I.Candidate_Id=[Tbl_Candidate_Personal_Det].[Candidate_Id]
left join Tbl_Agent_Settlement AGS on AGS.Invoice_Id=I.AgenInvoiceId 
where  Tbl_Agent.Agent_ID=@Agent_ID 
group by Commission_Setting_Id,AgenInvoiceId,[Candidate_Fname],[Candidate_Lname],groupname,name,NA.Batch_Id,C.IntakeId,
[Commission_Amount],[Agent_Name],EmpORAgent_Status 
)Base )A      
 SELECT SlNo,[Commission_Setting_Id],Student_name,
Feecode,Fee_Head_Name,
Commission_Amount, Name,totalamountpaid,
(Commission_Amount-totalamountpaid) as balance,
EmpORAgent_Status from #TEMP2 order by Student_name
end
end
    ')
END
