IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Admission_OnlineApplicationReportfilter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[sp_Admission_OnlineApplicationReportfilter] --1442
(
@CouncellorID bigint = 0,
@Fromdate varchar(MAX)='''',
@todate varchar(MAX)=''''
)
as
begin
Declare @withdraw bigint
Declare @Reject bigint
Declare @PaymentReceived bigint
Declare @Offersend bigint
Declare @Reply bigint
--Declare @Called bigint
Declare @Follow bigint
Declare @Reads bigint
Declare @New bigint
Declare @Counsellor Varchar(MAX)

set @withdraw=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  ApplicationStatus=''Withdrawn''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where  ApplicationStatus=''Withdrawn''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))U)

set @Reject=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  ApplicationStatus=''rejected''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where  ApplicationStatus=''rejected''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))M)

set @PaymentReceived=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where  ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))B)

set @Offersend=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where   ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))Y)

set @Reply=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where  ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where  ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))C)
--set @Called=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'')
set @Reads=(select count(*) from Tbl_EnquiryAttendence  where 
                                   (((CONVERT(date,AttendedDateTime)) >= @Fromdate and (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,AttendedDateTime)) >= @Fromdate)))


set @follow=(select count(Candidate_Id)from Tbl_FollowUp_Detail where 
                                   (((CONVERT(date,Followup_Date)) >= @Fromdate and (CONVERT(date,Followup_Date)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,Followup_Date)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,Followup_Date)) >= @Fromdate)))
set @New=(select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)) )- (select count(DISTINCT CandidateID) from Tbl_EnquiryAttendence where 
                                    
                                   (((CONVERT(date,AttendedDateTime)) >= @Fromdate and (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,AttendedDateTime)) >= @Fromdate))and CandidateID in(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)) )))
--set @Counsellor=(select Employee_FName+'' ''+Employee_LName from Tbl_Employee where Employee_Id=@CouncellorID)
    
    begin
        
     Create table #tempchart(valuetype varchar(Max),value bigint)
insert into #tempchart
select''withdraw'',@withdraw as withdraw union all
select''Reject'',@Reject as Reject union all
select''PaymentReceived'',@PaymentReceived as [Payment Received] union all
select ''Offersend'',@Offersend as  Offersend union all
select ''Reply'',@Reply as  Reply union all
select ''Follow'',@Follow as Follow union all
--select ''Called'',@Called as  Called union all
select ''Reads'',@Reads as  Reads union all
select ''New'',@New as  New 


select * from #tempchart --where value!=0



end
end
    ');
END
