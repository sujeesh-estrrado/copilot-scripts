IF NOT EXISTS (
    SELECT 1 FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentCollection_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Finance_StudentCollection_Report] -- 0,1,1,null,null
(
@flag bigint = 0,
@Intake bigint = 0,
@Program bigint = 0,
@MethodofPayment bigint = 0,
@Accountcode bigint = 0,
@fromdate datetime=null,
@Todate datetime=null,
@PageSize  bigint = 10,
@CurrentPage  bigint = 1
)
as

begin
if(@flag=0)
begin
select 
CONCAT(Candidate_Fname,'''',Candidate_Lname) as CandidateName,IDMatrixNo,
concat(DE.Course_Code,''-'',DE.Department_Name)as Department_Name,PD.Candidate_Id,
sp.receiptnumber as ReceiptNumber1, SUM(sp.amount) AS amount, sp.remarks as Remarks,
pm.name as paymentmethods,b.name,
CONVERT(VARCHAR(10), sp.datetimeissued, 105) as datetimeissued,ST.DOCNO AS ReceiptNumber

from Tbl_Candidate_Personal_Det PD
left join student_payment sp on PD.Candidate_Id=sp.studentid
left join fixed_payment_method pm on pm.id=sp.paymentmethod
 left join ref_bank b on b.id=sp.bankname

left join tbl_New_Admission NA on NA.New_Admission_Id=PD.New_Admission_Id
 left join tbl_Department  DE on DE.Department_Id=NA.Department_Id
 left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
   left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID
   LEFT JOIN student_transaction ST ON ST.transactionid = SP.transactionid

where (sp.paymentmethod=@MethodofPayment or @MethodofPayment=0)and 
--(@Intake=0 or NA.Batch_Id=@Intake) 
(@Intake=0 or IM.id=@Intake)
and (@Program=0 or NA.Department_Id=@Program) 
and (@Accountcode=0 or sp.accountcodeid=@Accountcode)
and (((CONVERT(date,sp.datetimeissued)) >= @fromdate and (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))
OR (@fromdate IS NULL AND @Todate IS NULL)
OR (@fromdate IS NULL AND (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))

OR (@Todate IS NULL AND (CONVERT(date,sp.datetimeissued)) >= @fromdate)) 
 GROUP BY PD.Candidate_Id, sp.receiptnumber,Candidate_Fname,Candidate_Lname,IDMatrixNo,Department_Name,sp.remarks,
 pm.name,b.name,sp.datetimeissued,DE.Course_Code,ST.DOCNO

ORDER BY sp.datetimeissued, PD.Candidate_Id
OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
end

if(@flag=1)
begin
 
select * into #temp from(
select CONCAT(Candidate_Fname,'''',Candidate_Lname) as CandidateName,IDMatrixNo,concat(DE.Course_Code,''-'',DE.Department_Name)as Department_Name,PD.Candidate_Id,
sp.receiptnumber as ReceiptNumber, SUM(sp.amount) AS amount, sp.remarks as Remarks,
pm.name as paymentmethods,b.name,
CONVERT(VARCHAR(10), sp.datetimeissued, 105) as datetimeissued

from Tbl_Candidate_Personal_Det PD
Inner join student_payment sp on PD.Candidate_Id=sp.studentid
left join fixed_payment_method pm on pm.id=sp.paymentmethod
 left join ref_bank b on b.id=sp.bankname

left join tbl_New_Admission NA on NA.New_Admission_Id=PD.New_Admission_Id
 left join tbl_Department  DE on DE.Department_Id=NA.Department_Id
 left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
  left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID

where (sp.paymentmethod=@MethodofPayment or @MethodofPayment=0)and 
(@Intake=0 or IM.id=@Intake) and (@Program=0 or NA.Department_Id=@Program) 
and (@Accountcode=0 or sp.accountcodeid=@Accountcode)
and (((CONVERT(date,sp.datetimeissued)) >= @fromdate and (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))
OR (@fromdate IS NULL AND @Todate IS NULL)
OR (@fromdate IS NULL AND (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))

OR (@Todate IS NULL AND (CONVERT(date,sp.datetimeissued)) >= @fromdate)) 
 GROUP BY PD.Candidate_Id, sp.receiptnumber,Candidate_Fname,Candidate_Lname,IDMatrixNo,Department_Name,sp.remarks,
 pm.name,b.name,sp.datetimeissued,DE.Course_Code
)base
select count(*)as counts,sum(amount) as totamount from #temp
end

end
    ')
END
GO
