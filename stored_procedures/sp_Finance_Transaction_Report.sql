IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Transaction_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Finance_Transaction_Report] --0,0,0,''all'',''2018-09-01 00:00:00.000'',null,1,100000
(
@flag bigint=0,
@IntakeId varchar(MAX)='''',
@PgmID varchar(MAX)='''',
@TransavtionType varchar(Max)='''',
@fromdate datetime=null,
@Todate datetime=null,
@CurrentPage int=1,                                 
@PageSize int=10  ,
@Payment_Status varchar(Max)=''''
)
as
begin
if(@flag=0)
  begin
    if(@TransavtionType=''All'')
    begin
      SELECT  Pd.Candidate_Id,
        concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
        Pd.AdharNumber, Pd.IDMatrixNo,
        --IM.intake_no as Batch_Code,
        IM.Batch_Code as Batch_Code,
        Ad.Batch_Id AS IntakeID, concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
        Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
        st.docno as Documentno,SBG.docno as invoiceNo,
        CAST(st.amount AS DECIMAL(18, 2))AS amount,
        fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
        when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
        when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
        end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
        case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
        sb.totalamountpaid as PaidAmount,
        case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
      FROM Tbl_Candidate_Personal_Det pd  
      inner join student_transaction st on st.studentid=pd.Candidate_Id
      left join fixed_payment_method fpm on fpm.id=paymentmethod
      left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left outer join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
      where 
      (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
      and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''')and 
      st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
       order by Documentno asc
       OFFSET @PageSize * (@CurrentPage - 1) ROWS
       FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    

    end
    
  else if(@TransavtionType=''0'')
    begin
    if(@Payment_Status=''All'')
    begin
      SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, 
      --IM.intake_no as Batch_Code,
      IM.Batch_Code as Batch_Code,
      Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
         order by Documentno asc
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
        end
        else if(@Payment_Status=''0'')
        begin
        SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, 
      --IM.intake_no as Batch_Code,
      IM.Batch_Code as Batch_Code,
      Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        sb.totalamountpaid=sb.totalamountpayable and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
         order by Documentno asc
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
        end
        else if(@Payment_Status=''1'')
        begin
        SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, 
      --IM.intake_no as Batch_Code,
      IM.Batch_Code as Batch_Code,
      Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        (sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid>0)and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
         order by Documentno asc
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
        end
        else if(@Payment_Status=''2'')
        begin
        SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, 
      --IM.intake_no as Batch_Code,
      IM.Batch_Code as Batch_Code,
      Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        sb.totalamountpaid=0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
         order by Documentno asc
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
        end
    end
    else
    begin
    SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, 
      --IM.intake_no as Batch_Code,
      IM.Batch_Code as Batch_Code,
      Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
         order by Documentno asc
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    end
  end
  if(@flag=1)
  begin
    if(@TransavtionType=''All'')
    begin
      select * into #temp from(SELECT  Pd.Candidate_Id,
        concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
        Pd.AdharNumber, Pd.IDMatrixNo,IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID, concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
        Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
        st.docno as Documentno,SBG.docno as invoiceNo,
        CAST(st.amount AS DECIMAL(18, 2))AS amount,
        fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
        when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
        when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
        end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
        case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
      FROM Tbl_Candidate_Personal_Det pd  
      inner join student_transaction st on st.studentid=pd.Candidate_Id
      left join fixed_payment_method fpm on fpm.id=paymentmethod
      left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
      left join student_bill sb on sb.billgroupid=SBG.billgroupid
      where (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
      st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
       )base
       select count(*)as counts,sum(amount)as totamount from #temp

    end
  else if(@TransavtionType=''0'')
    begin
    if(@Payment_Status=''All'')
    begin
      select * into #temp1 from(SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
        left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
      )base1
       select count(*)as counts,sum(amount)as totamount from #temp1
       end
      else if(@Payment_Status=''0'')
    begin
      select * into #temp2 from(SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
        left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        sb.totalamountpaid=sb.totalamountpayable and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
      )base1
       select count(*)as counts,sum(amount)as totamount from #temp2
       end
    else   if(@Payment_Status=''1'')
    begin
      select * into #temp3 from(SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
        left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
          (sb.totalamountpaid<sb.totalamountpayable and sb.totalamountpaid>0) and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
      )base1
       select count(*)as counts,sum(amount)as totamount from #temp3
       end
       if(@Payment_Status=''2'')
    begin
      select * into #temp4 from(SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
        left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
          sb.totalamountpaid=0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
      )base1
       select count(*)as counts,sum(amount)as totamount from #temp4
       end
    end
    else
    begin
    select * into #temp5 from(SELECT  Pd.Candidate_Id,
      concat(Pd.Candidate_Fname,'' '',Pd.Candidate_Lname)as CandidateName, st.billcancel,
      Pd.AdharNumber, Pd.IDMatrixNo, IM.intake_no as Batch_Code, Ad.Batch_Id AS IntakeID,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name, 
      Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
       st.docno as Documentno,SBG.docno as invoiceNo,
       CAST(st.amount AS DECIMAL(18, 2))AS amount,
      fpm.name as paymentmethod,case when transactiontype=''0''then ''Invoice'' 
      when transactiontype=''1'' then ''Receipt'' when transactiontype=''2'' then ''Debit Note'' 
      when transactiontype=''3'' then ''Credit Note'' when transactiontype=''4'' then ''Refund'' when transactiontype=''4'' then ''Group Receipt'' 
      end as transactiontype,CONVERT(VARCHAR(10), datetimeissued,105 )as datetimeissued,concat(st.description,'' '',st.remarks) as transactiondescription,
      case when cashierid=0 then ''System'' when cashierid=1 then ''Admin'' else CONCAT(e.Employee_FName,'' '',Employee_LName) end as Issuedby,
          sb.totalamountpaid as PaidAmount,
          case when sb.totalamountpayable=sb.totalamountpaid then ''Fully Paid'' 
        when sb.totalamountpayable>sb.totalamountpaid and sb.totalamountpaid > 0 then ''Partially Paid''
        when sb.totalamountpaid=0 then ''Not Paid'' 
        end
        as Payment_Status
        FROM Tbl_Candidate_Personal_Det pd  
          inner join student_transaction st on st.studentid=pd.Candidate_Id
        left join fixed_payment_method fpm on fpm.id=paymentmethod
        left join Tbl_Employee e on E.Employee_Id=st.cashierid
  
      left join tbl_New_Admission Ad on pd.New_Admission_Id=Ad.New_Admission_Id
      left join Tbl_Course_Batch_Duration bd on bd.Batch_Id=ad.Batch_Id
      left join Tbl_IntakeMaster IM on IM.id=bd.IntakeMasterID 
      left join Tbl_Department AS D ON D.Department_Id = ad.Department_Id
      left join student_bill_group as SBG on SBG.billgroupid = st.billgroupid
        left join student_bill sb on sb.billgroupid=SBG.billgroupid
        where 
        transactiontype=@TransavtionType and 
        (IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) or @IntakeId='''')
and ( Ad.Department_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) or @PgmID='''') and 
        st.amount>0 and
        (((CONVERT(date,datetimeissued)) >= @fromdate and (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate)) 
       OR (@fromdate IS NULL AND @Todate IS NULL)
       OR (@fromdate IS NULL AND (CONVERT(date,datetimeissued)) < DATEADD(day,1,@Todate))
       OR (@Todate IS NULL AND (CONVERT(date,datetimeissued)) >= @fromdate))
  
      )base1
       select count(*)as counts,sum(amount)as totamount from #temp5
    end
  end
end
    ')
END
