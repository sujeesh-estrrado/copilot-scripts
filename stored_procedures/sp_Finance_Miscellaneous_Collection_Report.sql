IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Miscellaneous_Collection_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_Finance_Miscellaneous_Collection_Report]  --0,0,null,null
(
@Cashier bigint = 0,
@MethodofPayment bigint = 0,
@fromdate datetime=null,
@Todate datetime=null
)
as

begin

select sp.description,CAST(isnull(sp.amount,0) AS DECIMAL(18, 2))as amount,


 CONCAT(pd.Candidate_Fname,'' '',pd.Candidate_Lname) as studentname,''''as TypeofCharges,pm.name as paymentmethod,

st.docno,refno,sp.remarks,
convert(varchar(50),sp.datetimeissued,105)datetimeissued,
case when rb.name is null then ''N/A'' when rb.name='''' then ''N/A'' else rb.name end as bankname,
case when sp.cashierid=''0'' then ''System'' when sp.cashierid=''1'' then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName)
end as Cashiername,sp.cashierid
 from student_payment sp 
left join student_transaction st on st.transactionid=sp.transactionid
left join Tbl_Candidate_Personal_Det pd on  Pd.Candidate_Id=sp.studentid
left join fixed_payment_method pm on pm.id=sp.paymentmethod
left join ref_bank rb on rb.id=sp.bankname
left join Tbl_Employee E on E.Employee_Id=sp.cashierid
where transactiontype=1 and (sp.cashierid=@Cashier or @Cashier=0) and (sp.paymentmethod=@MethodofPayment or @MethodofPayment=0)
and (((CONVERT(date,sp.datetimeissued)) >= @fromdate and (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,sp.datetimeissued)) >= @fromdate)) order by datetimeissued


end
    ')
END
GO
