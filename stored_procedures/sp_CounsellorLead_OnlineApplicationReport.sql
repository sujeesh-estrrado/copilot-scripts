IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_CounsellorLead_OnlineApplicationReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[sp_CounsellorLead_OnlineApplicationReport]--1440
(
@CouncellorID bigint = 0
)
as
begin
Declare @withdraw bigint
Declare @Reject bigint
Declare @PaymentReceived bigint
Declare @Offersend bigint
Declare @Reply bigint
--Declare @Called bigint
Declare @Reads bigint
Declare @follow bigint
Declare @New bigint
Declare @Counsellor Varchar(MAX)

set @withdraw=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''Withdrawn''and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
set @Reject=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''rejected'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
set @PaymentReceived=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
set @Offersend=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
set @Reply=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'' and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
--set @Called=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''approved'')
set @Reads=(select count(*) from Tbl_EnquiryAttendence EA left join Tbl_Candidate_Personal_Det CPD on EA.CouncellorID=CPD.CounselorEmployee_id where CouncellorID = @CouncellorID  and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()) )



set @follow=(select count(Candidate_Id)from Tbl_Candidate_Personal_Det where CounselorEmployee_id=@CouncellorID and ApplicationStatus=''Follow''and MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()))
set @New=(select (select count(Candidate_Id) from Tbl_Candidate_Personal_Det where  MONTH(RegDate) = MONTH(GetDate()) AND YEAR(RegDate) = YEAR(GetDate()) and CounselorEmployee_id=@CouncellorID)- (select count(*) from Tbl_EnquiryAttendence where CouncellorID = @CouncellorID))
set @Counsellor=(select Employee_FName+'' ''+Employee_LName from Tbl_Employee where Employee_Id=@CouncellorID )
    
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
