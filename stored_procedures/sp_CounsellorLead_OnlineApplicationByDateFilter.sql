IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_CounsellorLead_OnlineApplicationByDateFilter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                   

CREATE procedure [dbo].[sp_CounsellorLead_OnlineApplicationByDateFilter]--1440
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
Declare @Reads bigint
Declare @follow bigint
Declare @New bigint
Declare @Counsellor Varchar(MAX)


set @withdraw=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''Withdrawn''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''Withdrawn''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))U)

set @Reject=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''rejected''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''rejected''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))M)

set @PaymentReceived=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))B)

set @Offersend=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))Y)

set @Reply=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate))
                                   union all

select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved''and 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)))C)
--set @Called=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'')
set @Reads=(select count(*) from Tbl_EnquiryAttendence  where CouncellorID = @CouncellorID  and 
                                   (((CONVERT(date,AttendedDateTime)) >= @Fromdate and (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,AttendedDateTime)) >= @Fromdate)))


set @follow=(select count(Candidate_Id)from Tbl_FollowUp_Detail where Counselor_Employee=@CouncellorID and 
                                   (((CONVERT(date,Followup_Date)) >= @Fromdate and (CONVERT(date,Followup_Date)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,Followup_Date)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,Followup_Date)) >= @Fromdate)))
set @New=(select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)) and CounselorEmployee_id=@CouncellorID)- (select count(DISTINCT CandidateID) from Tbl_EnquiryAttendence where CouncellorID = @CouncellorID
                                   and 
                                   (((CONVERT(date,AttendedDateTime)) >= @Fromdate and (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,AttendedDateTime)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,AttendedDateTime)) >= @Fromdate))and CandidateID in(select count(Candidate_Id) from Tbl_Candidate_Personal_Det where 
                                   (((CONVERT(date,RegDate)) >= @Fromdate and (CONVERT(date,RegDate)) < DATEADD(day,1,@todate)) 
                                   OR (@Fromdate IS NULL AND @todate IS NULL)
                                   OR (@Fromdate IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@todate))
                                   OR (@todate IS NULL AND (CONVERT(date,RegDate)) >= @Fromdate)) and CounselorEmployee_id=@CouncellorID)))
set @Counsellor=(select Employee_FName+'' ''+Employee_LName from Tbl_Employee where Employee_Id=@CouncellorID)
    

    
    
    begin
        
     Create table #tempchart(withdraw varchar(Max),Reject varchar(Max),PaymentReceived varchar(Max),
     Offersend varchar(Max),Reply varchar(Max),Reads varchar(Max),New varchar(Max),Follow varchar(Max))
insert into #tempchart
select @withdraw as withdraw ,@Reject as Reject ,@PaymentReceived as [Payment Received] ,@Offersend as  Offersend 
,@Reply as  Reply,@Reads as  Reads,@New as  New ,@follow as Follow

select * from #tempchart --where value!=0



end
end

    ')
END
