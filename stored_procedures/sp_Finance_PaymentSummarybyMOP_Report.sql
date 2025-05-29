IF NOT EXISTS (
    SELECT 1 FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_PaymentSummarybyMOP_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Finance_PaymentSummarybyMOP_Report] -- 0,0,0,1,null,null,100,1
(
@flag bigint = 0,
@ProgrammeType bigint = 0,
@Intake varchar(MAX)='''',
@PgmID varchar(MAX)='''',
@MethodofPayment bigint = 0,
@fromdate datetime=null,
@Todate datetime=null,
@PageSize bigint=10,
@CurrentPage bigint=1
)
as

begin
if(@flag = 0)
    begin
        select distinct PD.Candidate_Id,Concat(Candidate_Fname,'' '',Candidate_Lname)as studentName,
        concat(D.Course_Code,''-'',D.Department_Name) as Department_Name,IM.intake_no as Batch_Code,IDMatrixNo,AdharNumber,
        case when sp.cashierid=''0'' then ''System'' when sp.cashierid=''1'' then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName)
        end as Cashiername,pm.name as paymentmethod,convert(varchar(50),sp.datetimeissued,105)datetimeissued,st.docno,IM.Batch_Code,
        sp.amount
         from tbl_Candidate_Personal_Det PD
        left join tbl_New_Admission NA on NA.New_Admission_Id=PD.New_Admission_Id
        left join Tbl_Department D on D.Department_Id=NA.Department_Id
        left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
           left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterID
        left join student_payment sp on sp.studentid=PD.Candidate_Id
         left join Tbl_Employee E on E.Employee_Id=sp.cashierid 
         left join fixed_payment_method pm on pm.id=sp.paymentmethod
         left join student_transaction st on st.studentid=sp.studentid

        where ApplicationStatus=''Completed''and (NA.Course_Category_Id=@ProgrammeType or @ProgrammeType=0) and
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')
            and ( NA.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''')and 
        transactiontype=1  and (sp.paymentmethod=@MethodofPayment or @MethodofPayment=0)
        and (((CONVERT(date,sp.datetimeissued)) >= @fromdate and (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate)) 
         OR (@fromdate IS NULL AND @Todate IS NULL)
         OR (@fromdate IS NULL AND (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))
         OR (@Todate IS NULL AND (CONVERT(date,sp.datetimeissued)) >= @fromdate))
         order by datetimeissued 
         OFFSET @PageSize * (@CurrentPage - 1) ROWS
         FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    end
    if(@flag = 1)
    begin
        
        with level1 as (select distinct PD.Candidate_Id,Concat(Candidate_Fname,'' '',Candidate_Lname)as studentName,
        concat(D.Course_Code,''-'',D.Department_Name) as Department_Name,IM.intake_no as Batch_Code,IDMatrixNo,AdharNumber,
        case when sp.cashierid=''0'' then ''System'' when sp.cashierid=''1'' then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName)
        end as Cashiername,pm.name as paymentmethod,convert(varchar(50),sp.datetimeissued,105)datetimeissued,st.docno,
        sp.amount
         from tbl_Candidate_Personal_Det PD
        left join tbl_New_Admission NA on NA.New_Admission_Id=PD.New_Admission_Id
        left join Tbl_Department D on D.Department_Id=NA.Department_Id
        left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
           left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterID
        left join student_payment sp on sp.studentid=PD.Candidate_Id
         left join Tbl_Employee E on E.Employee_Id=sp.cashierid 
         left join fixed_payment_method pm on pm.id=sp.paymentmethod
         left join student_transaction st on st.studentid=sp.studentid

        where ApplicationStatus=''Completed''and (NA.Course_Category_Id=@ProgrammeType or @ProgrammeType=0) and
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')
            and ( NA.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''')and 
        transactiontype=1  and (sp.paymentmethod=@MethodofPayment or @MethodofPayment=0)
        and (((CONVERT(date,sp.datetimeissued)) >= @fromdate and (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate)) 
         OR (@fromdate IS NULL AND @Todate IS NULL)
         OR (@fromdate IS NULL AND (CONVERT(date,sp.datetimeissued)) < DATEADD(day,1,@Todate))
         OR (@Todate IS NULL AND (CONVERT(date,sp.datetimeissued)) >= @fromdate))
        )
         select count(*) as totcount,sum(amount) as totamount from level1
    end

end
    ')
END
GO
