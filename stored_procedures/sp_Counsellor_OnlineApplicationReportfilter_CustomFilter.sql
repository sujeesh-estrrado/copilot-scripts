IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Counsellor_OnlineApplicationReportfilter_CustomFilter')
BEGIN
    EXEC('
        
CREATE procedure [dbo].[sp_Counsellor_OnlineApplicationReportfilter_CustomFilter] --1442
(
@CouncellorID bigint = 0,
@FacultyId  NVARCHAR(MAX),
    @ProgrammeId  NVARCHAR(MAX),
    @IntakeId  NVARCHAR(MAX)
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
DECLARE @FacultyTable TABLE (FacultyId INT);
    DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
    DECLARE @IntakeTable TABLE (IntakeId INT);

    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');

    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');

    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');


set @withdraw=(select Count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det CPD

    LEFT JOIN 
        tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
where CPD.CounselorEmployee_id=@CouncellorID and CPD.ApplicationStatus=''Withdrawn'' 
and MONTH(CPD.RegDate) = MONTH(GetDate()) AND YEAR(CPD.RegDate) = YEAR(GetDate())

        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
union all
select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''Withdrawn'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))W)

set @Reject=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''rejected'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())
union all
select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''rejected'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))r)


set @PaymentReceived=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())
union all
select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))l)

set @Offersend=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())
union all
select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))k)

set @Reply=(select count(*) from (select Candidate_Id from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())
union all
select Candidate_Id from Tbl_Student_NewApplication where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))R)

--set @Called=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'')
set @Reads=(select count(*) from Tbl_EnquiryAttendence where CouncellorID = @CouncellorID  and MONTH(AttendedDateTime) = MONTH(GetDate()) AND YEAR(AttendedDateTime) = YEAR(GetDate()))

set @Follow=(select count(Candidate_Id)from Tbl_FollowUp_Detail where Counselor_Employee=@CouncellorID and MONTH(Followup_Date) = MONTH(GetDate()) AND YEAR(Followup_Date) = YEAR(GetDate()))

set @New=(select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det
where MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())and CounselorEmployee_id=@CouncellorID)- 
(select count(DISTINCT CandidateID) from Tbl_EnquiryAttendence where CouncellorID = @CouncellorID and MONTH(AttendedDateTime) = MONTH(GetDate()) AND YEAR(AttendedDateTime) = YEAR(GetDate())and CandidateID 
in((select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate())and CounselorEmployee_id=@CouncellorID)))))

set @Counsellor=(select Employee_FName+'' ''+Employee_LName from Tbl_Employee where Employee_Id=@CouncellorID)
    
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
