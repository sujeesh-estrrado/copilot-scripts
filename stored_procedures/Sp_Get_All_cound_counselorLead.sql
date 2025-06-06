IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_cound_counselorLead]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Sp_Get_All_cound_counselorLead] --3,3
(@id bigint,@emp_id bigint)

as
begin

  if(@id=1)
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where 
     ApplicationStatus=''Preactivated'' and (counselorEmployee_id=@emp_id or @emp_id=0)) m
     
    -- union all
     
    --select Candidate_Id from Tbl_Student_NewApplication where 
    --(ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or ApplicationStatus=''rejected''
    --or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Preactivated'')) m
  end
  else if(@id=2)---Total enquiey
  begin
    
      
  select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where (ApplicationStatus=''approved'' ) 
    and (counselorEmployee_id=@emp_id or @emp_id=0)and  Active_Status IN (''Active'', ''ACTIVE'')  )s
    --union all

    --select Candidate_Id from Tbl_Student_NewApplication where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) 
    --and counselorEmployee_id=@emp_id)s

  end
  else if(@id=3) --Verified count
  begin



  select count(*) from (SELECT CPD.Candidate_Id FROM dbo.Tbl_Candidate_Personal_Det AS CPD where (CounselorEmployee_id=@emp_id or @emp_id =0)
    and ( CPD.ApplicationStatus=''Verified''  ) and CPD.Candidate_DelStatus=0 )h
  --union all
  
  --  SELECT Candidate_Id FROM dbo.Tbl_Student_NewApplication  where (CounselorEmployee_id=@emp_id)
 --   and (ApplicationStatus=''approved'' or ApplicationStatus=''Verified''  
 --   or  ApplicationStatus=''Conditional_Admission'' or  ApplicationStatus=''Preactivated'') and Candidate_DelStatus=0)h


  end
  else if(@id=4)
  begin
    
     --select count( *) from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and active in(3,4,5)
     --and CounselorEmployee_id=@emp_id
     SELECT COUNT(DISTINCT CPD.Candidate_Id)
FROM Tbl_Candidate_Personal_Det CPD
LEFT JOIN Tbl_Student_status S ON S.id = CPD.active
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Student_Semester ON Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Course_Batch_Duration bd ON n.Batch_Id = bd.Batch_Id
LEFT JOIN Tbl_IntakeMaster im ON im.id = bd.intakemasterid
LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = n.Department_Id
LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id
LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
WHERE 
     ApplicationStatus = ''Completed''
    AND CPD.active IN (3, 4, 5) 
  and (CounselorEmployee_id=@emp_id or @emp_id =0)
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=5)--Approved candidate Count
  begin
    select count (*) from(select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'' and  (CounselorEmployee_id=@emp_id or @emp_id=0)) l
    --union all 
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Approved'' and CounselorEmployee_id=@emp_id) l
  end
  else if(@id=6) 
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  (CounselorEmployee_id=@emp_id or @emp_id=0)
    and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited''))m
    --union all
    --select Candidate_Id from Tbl_Candidate_Personal_Det where counselorEmployee_id=@emp_id)m
  end
  else if(@id=7)--Total paid candidate Count
  begin
    select count(distinct Candidate_Id)as paidcount from Tbl_Candidate_Personal_Det D left join student_bill b on D.Candidate_Id=b.studentid
 where ApplicationStatus=''rejected'' and (CounselorEmployee_id=@emp_id or @emp_id=0)
 
  
  end
  else if(@id=8)--On Hold candidate Count
  begin
    select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where  (CounselorEmployee_id=@emp_id or @emp_id=0) and M.status=''Hold''
  end
  else if(@id=9)--Pending Followups candidate Count
  begin
    
--    select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
--Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
--left join tbl_employee e on e.employee_id =F.counselor_employee
--where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'') and e.employee_status=0 and (CounselorEmployee_id=@emp_id or @emp_id = 0) and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
  
  select count(Distinct cpd.Candidate_Id) as Followcount from tbl_candidate_personal_det cpd 
left  join Tbl_FollowUp_Detail f on f.candidate_id = cpd.candidate_id
left join tbl_employee e on e.Employee_Id = cpd.CounselorEmployee_id
where (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''pending''
or cpd.ApplicationStatus=''Pending'' or cpd.ApplicationStatus=''submited'') 
and (cpd.Counseloremployee_id=@emp_id or @emp_id=0 or cpd.Counseloremployee_id=0) 
and (e.Employee_Status=0 or cpd.CounselorEmployee_id=0) end
  else if(@id=10)--rejected candidate Count
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''rejected'' and  (CounselorEmployee_id=@emp_id or @emp_id=0))k 
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''rejected'' and  CounselorEmployee_id=@emp_id)k
  end
  else if(@id=11)--New candidate Count
  begin
  with level1 as(
select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and
CounselorEmployee_id=@emp_id)-
(select count(distinct CandidateID) from Tbl_EnquiryAttendence
inner join Tbl_Candidate_Personal_Det on CandidateID=Candidate_Id
where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and (CouncellorID = @emp_id or @emp_id=0) and CandidateID!=0 ) as count)
select case when count>0 then count else 0 end as counts from level1

  
  --select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@emp_id)- (select count(distinct CandidateID) from Tbl_EnquiryAttendence where CouncellorID = @emp_id and CandidateID!=0 );
  end
  else if(@id=12)--Approved candidate Count for admission
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Approved'')e
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Approved'')e
  end
  else if(@id=13) --verified count admission
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' 
    or ApplicationCategory=''Preactivated'')g
    --union all
  --  select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'')g

  end
  else if(@id=14)
begin
  select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'')r
  --union all
  --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'')r
end

else if(@id=15)--Total paid candidate Count
  begin
    select count(distinct Candidate_Id)as paidcount from Tbl_Candidate_Personal_Det D left join student_bill b on D.Candidate_Id=b.studentid
 where ( ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or 
 ApplicationStatus=''rejected'' or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission''
 or ApplicationStatus=''Preactivated'' or ApplicationStatus=''Completed'')  
 and (ApplicationStage=''Submit without payment'' or ApplicationStage=''Submited with payment'')
  and billgroupid  in  
(select billgroupid from student_transaction where semesterno = -1 and outstandingbalance>0 
and studentid=Candidate_Id and billcancel = 0)
  
  end

  else if(@id=16)--On Hold candidate Count
  begin
    select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where   M.status=''Hold''
  end

  else if(@id=17)--Pending Followups candidate Count
  begin
    select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'')  and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
  end
  else if(@id=18)
  begin
    
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'') and (CounselorEmployee_id=0))t 
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
  else if(@id=19)
  begin
SELECT count (*) 
FROM Tbl_Candidate_Personal_Det c
WHERE c.Candidate_Id NOT IN (
    SELECT DISTINCT candidateid 
    FROM Tbl_offerletter_log 
    WHERE sendby = 1
);

--SELECT COUNT(*) AS TotalCandidates
--FROM Tbl_Candidate_Personal_Det c
--WHERE NOT EXISTS (
--    SELECT 1 FROM tbl_approval_log a
--    WHERE c.Candidate_Id = a.Candidate_Id AND a.Offerletter_sent = 1


end
else if(@id=20)
begin
--SELECT COUNT(DISTINCT candidateid) AS candidate_count
--FROM Tbl_offerletter_log 
--WHERE offeracceptstatus IS NULL;
----SELECT count( *) FROM tbl_approval_log WHERE Offerletter_sent = 1 AND Offerletter_status is NULL and offer_letter_accept_date is null;

SELECT COUNT(DISTINCT candidateid) AS total_candidates
FROM Tbl_offerletter_log 
WHERE offeracceptstatus IS NULL AND status IS NULL;
  end
  else if(@id=21)
  begin
WITH RankedCandidates AS (
    SELECT 
        CPD.New_Admission_Id AS AdmnID,
        ROW_NUMBER() OVER (PARTITION BY CPD.New_Admission_Id ORDER BY CPD.Candidate_Id) AS RowNum
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD 
        LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
            AND dbo.tbl_approval_log.delete_status = 0 
        LEFT JOIN Tbl_Offerlettre ol ON ol.candidate_id = CPD.Candidate_Id 
            AND ol.delete_status = 0 
        LEFT JOIN Approval_Request R ON CPD.candidate_id = R.StudentId 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
    WHERE 
        -- Filtering only "Pending finance clearance" students AND verified applications
        CPD.ApplicationStatus = ''verified'' 
        AND (
            (ApprovalStatus IS NULL AND R.RefundStatus IS NULL) 
            OR (ApprovalStatus = 1 AND R.RefundStatus IS NULL) 
            OR (ApprovalStatus = 1 AND R.RefundStatus = 0)
        ) 
)
SELECT COUNT(*) AS UniqueAdmnIDCount
FROM RankedCandidates 
WHERE RowNum = 1;


  end
  else if (@id=22)
  begin
  DECLARE @sql NVARCHAR(MAX)
    DECLARE @columns NVARCHAR(MAX)

-- Generate the list of columns dynamically based on distinct Respond_Type values
SELECT @columns = STRING_AGG(
    CONCAT(
        ''SUM(CASE WHEN UPPER(LTRIM(RTRIM(Respond_Type))) = '''''', 
        UPPER(LTRIM(RTRIM(Respond_Type))), 
        '''''' THEN 1 ELSE 0 END) AS ['', 
        UPPER(LTRIM(RTRIM(Respond_Type))), 
        '']''
    ), '', '')
FROM (
    SELECT DISTINCT Respond_Type 
    FROM Tbl_FollowUpLead_Detail
) AS DistinctRespondTypes

-- Construct the full SQL query
SET @sql = ''
SELECT '' + @columns + ''
FROM Tbl_FollowUpLead_Detail
''

-- Execute the dynamic SQL
EXEC sp_executesql @sql
end
else if (@id=23)
begin

-- Generate the list of columns dynamically based on distinct Respond_Type values
SELECT @columns = STRING_AGG(
    ''SUM(CASE WHEN UPPER(LTRIM(RTRIM(Respond_Type))) = '''''' + 
    UPPER(LTRIM(RTRIM(Respond_Type))) + '''''' THEN 1 ELSE 0 END) AS ['' + 
    UPPER(LTRIM(RTRIM(Respond_Type))) + '']'', '', '')
FROM (
    SELECT DISTINCT Respond_Type 
    FROM Tbl_FollowUp_Detail
) AS distinctRespondTypes;

-- Construct the full SQL query
SET @sql = ''
SELECT '' + @columns + ''
FROM Tbl_FollowUp_Detail'';

-- Execute the dynamic SQL
EXEC sp_executesql @sql;

end
  
  else if (@id=24)
  begin
  SELECT SUM(totalamountpayable) AS TotalAmountPayable
FROM student_bill
WHERE YEAR(datecreated) = YEAR(GETDATE());
end
else if (@id=25)
begin

SELECT SUM (outstandingbalance) FROM student_bill
end
else if(@id=26)
begin

select sum (outstandingbalance) from student_bill where YEAR(datecreated)=YEAR(GETDATE());
end
ELSE IF(@id = 27)
BEGIN
DECLARE @currentDate DATE = GETDATE();
DECLARE @fourMonthsAgo DATE = DATEADD(MONTH, -3, @currentDate);

WITH MonthlyData AS (
    SELECT 
        FORMAT(st.datetimeissued, ''yyyy-MM'') AS MonthYear, -- Format as ''YYYY-MM'' for sorting
        DATENAME(MONTH, st.datetimeissued) + '' '' + CAST(YEAR(st.datetimeissued) AS VARCHAR) AS MonthLabel, 
        YEAR(st.datetimeissued) AS YearCreated,  
        MONTH(st.datetimeissued) AS MonthCreated,
        COUNT(st.docno) AS counts,
        SUM(st.amount) AS totamount,  
        SUM(sb.totalamountpayable - sb.totalamountpaid) AS outstanding_amount,
        SUM(CASE 
                WHEN sb.totalamountpayable = sb.totalamountpaid THEN st.amount 
                ELSE 0 
            END) AS fully_paid_amount,
        SUM(CASE 
                WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN st.amount 
                ELSE 0 
            END) AS partially_paid_amount,
        SUM(CASE 
                WHEN sb.totalamountpayable = sb.totalamountpaid THEN st.amount 
                WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN st.amount 
                ELSE 0 
            END) AS total_paid_amount
    FROM student_transaction st
    INNER JOIN student_bill sb ON sb.billgroupid = st.billgroupid
    WHERE st.transactiontype = ''0'' -- Only Invoice Transactions
    AND st.datetimeissued >= @fourMonthsAgo -- Filter last 4 months
    GROUP BY FORMAT(st.datetimeissued, ''yyyy-MM''), DATENAME(MONTH, st.datetimeissued), YEAR(st.datetimeissued), MONTH(st.datetimeissued)
)

SELECT 
    MonthLabel,  -- Example: "January 2025"
    YearCreated,
    MonthCreated,
    counts,
    totamount,
    outstanding_amount,
    fully_paid_amount,
    partially_paid_amount,
    total_paid_amount
FROM MonthlyData
ORDER BY MonthYear DESC; -- Order by latest month first

END

else if(@id=28)
begin

SELECT COUNT(Candidate_Id) AS ApprovedCount
FROM Tbl_Candidate_Personal_Det
WHERE ApplicationStatus = ''Approved''

end

else if(@id=29)
begin

-- Construct the column aggregation
-- Step 1: Generate the dynamic columns for the pivot
SELECT @columns = STRING_AGG(
    CONCAT(
        ''ISNULL(SUM(CASE WHEN UPPER(LTRIM(RTRIM(Respond_Type))) = '''''', 
        UPPER(LTRIM(RTRIM(Respond_Type))), 
        '''''' THEN 1 ELSE 0 END), 0) AS ['', 
        UPPER(LTRIM(RTRIM(Respond_Type))), 
        '']''
    ), '', '')
FROM (
    SELECT DISTINCT Respond_Type 
    FROM Tbl_FollowUpLead_Detail
) AS distinctRespondTypes;

-- Step 2: Generate the HAVING clause to check if any column sum is greater than 0
DECLARE @havingClause NVARCHAR(MAX);

SELECT @havingClause = STRING_AGG(
    CONCAT(
        ''ISNULL(SUM(CASE WHEN UPPER(LTRIM(RTRIM(Respond_Type))) = '''''', 
        UPPER(LTRIM(RTRIM(Respond_Type))), 
        '''''' THEN 1 ELSE 0 END), 0) > 0''
    ), '' OR '')
FROM (
    SELECT DISTINCT Respond_Type 
    FROM Tbl_FollowUpLead_Detail
) AS distinctRespondTypes;

-- Step 3: Construct the full SQL query
SET @sql = ''
SELECT '' + @columns + ''
FROM Tbl_FollowUpLead_Detail
WHERE TRY_CAST(Counselor_Employee AS BIGINT) = '' + CAST(@emp_id AS VARCHAR(20)) + ''
HAVING '' + @havingClause + '';'';

-- Step 4: Execute the dynamic SQL
EXEC sp_executesql @sql;



end
else if(@id=30)
begin

SELECT @columns = STRING_AGG(
    ''SUM(CASE WHEN UPPER(LTRIM(RTRIM(Respond_Type))) = '''''' + 
    UPPER(LTRIM(RTRIM(Respond_Type))) + '''''' THEN 1 ELSE 0 END) AS ['' + 
    UPPER(LTRIM(RTRIM(Respond_Type))) + '']'', '', '')
FROM (
    SELECT DISTINCT Respond_Type 
    FROM Tbl_FollowUp_Detail
) AS distinctRespondTypes;

-- Construct the full SQL query
SET @sql = ''
SELECT '' + @columns + ''
FROM Tbl_FollowUp_Detail
where Counselor_Employee='' +CAST(@emp_id AS VARCHAR(20)) + '''';

-- Execute the dynamic SQL
EXEC sp_executesql @sql;

end
else if(@id=31) 
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  (Agent_ID=@emp_id or @emp_id=0)
    and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited''))m
    --union all
    --select Candidate_Id from Tbl_Candidate_Personal_Det where counselorEmployee_id=@emp_id)m
  end
  else if(@id=32)---Total enquiey
  begin
    
      
  select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where (ApplicationStatus=''approved'' ) 
    and (Agent_ID=@emp_id or @emp_id=0))s
    --union all

    --select Candidate_Id from Tbl_Student_NewApplication where (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' ) 
    --and counselorEmployee_id=@emp_id)s

  end
  else if(@id=33) --Verified count
  begin



  select count(*) from (SELECT CPD.Candidate_Id FROM dbo.Tbl_Candidate_Personal_Det AS CPD where (Agent_ID=@emp_id or @emp_id =0)
    and ( CPD.ApplicationStatus=''Verified''  ) and CPD.Candidate_DelStatus=0 )h
  --union all
  
  --  SELECT Candidate_Id FROM dbo.Tbl_Student_NewApplication  where (CounselorEmployee_id=@emp_id)
 --   and (ApplicationStatus=''approved'' or ApplicationStatus=''Verified''  
 --   or  ApplicationStatus=''Conditional_Admission'' or  ApplicationStatus=''Preactivated'') and Candidate_DelStatus=0)h


  end
  if(@id=34)
  begin
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where 
     ApplicationStatus=''Preactivated'' and (Agent_ID=@emp_id or @emp_id=0)) m
     
    -- union all
     
    --select Candidate_Id from Tbl_Student_NewApplication where 
    --(ApplicationStatus=''Pending'' or ApplicationStatus=''submited'' or ApplicationStatus=''approved'' or ApplicationStatus=''rejected''
    --or ApplicationStatus=''Verified'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Preactivated'')) m
  end
  else if(@id=35)--Total paid candidate Count
  begin
    select count(distinct Candidate_Id)as paidcount from Tbl_Candidate_Personal_Det D left join student_bill b on D.Candidate_Id=b.studentid
 where ApplicationStatus=''rejected'' and (Agent_ID=@emp_id or @emp_id=0)
 
  
  end
  else if(@id=36)--On Hold candidate Count
  begin
    select Count(distinct M.Candidate_Id) as holdcount from Tbl_Status_change_by_Marketing M
left join Tbl_Candidate_Personal_Det D on M.Candidate_Id=D.candidate_Id
where  (Agent_ID=@emp_id or @emp_id=0) and M.status=''Hold''
  end
  else if(@id=37)--Pending Followups candidate Count
  begin
    
--    select count(Distinct F.Candidate_Id) as Followcount from Tbl_FollowUp_Detail F 
--Left join Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.candidate_Id
--left join tbl_employee e on e.employee_id =F.counselor_employee
--where FORMAT(Next_Date, ''yyyy-MM-dd'')>=FORMAT(GetDate(), ''yyyy-MM-dd'') and e.employee_status=0 and (CounselorEmployee_id=@emp_id or @emp_id = 0) and (ApplicationStatus=''Pending'' or ApplicationStatus=''submited'')
  
  select count(Distinct cpd.Candidate_Id) as Followcount from tbl_candidate_personal_det cpd 
left  join Tbl_FollowUp_Detail f on f.candidate_id = cpd.candidate_id
where (f.Next_Date is null or f.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''pending''
or cpd.ApplicationStatus=''Pending'' or cpd.ApplicationStatus=''submited'') 
and (cpd.Agent_ID=@emp_id or @emp_id=0 )end
else if(@id=38)
  begin
    
    select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''Completed'' and (Agent_ID=@emp_id or @emp_id=0))t 
    --union all
    --select Candidate_Id from Tbl_Student_NewApplication where ApplicationStatus=''Completed'' and CounselorEmployee_id=@emp_id)t 
  end
end
    ')
END
