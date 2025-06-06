IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_FollowUpLead_detail_duplicateByCandidateID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Delete_FollowUpLead_detail_duplicateByCandidateID]
(
    @candidateID bigint
)
AS
BEGIN
declare @firstLogID bigint,@duplicateCnt smallint,
    @Counselor_Employee varchar(200),@Candidate_Id bigint,@Followup_Date datetime,@Followup_time varchar(50),
    @Remarks varchar(200),@Respond_Type varchar(200),
    @Action_to_Be_Taken varchar(200),@Action_Taken bit,
    @Next_Date datetime,@Medium varchar(50),@Delete_Status bit


declare a cursor fast_forward for
    select min(Follow_Up_Detail_Id) firstLogID,count(distinct Follow_Up_Detail_Id) duplicateCnt,
        Counselor_Employee,Candidate_Id,Followup_Date,Followup_time,Remarks,Respond_Type,
        Action_to_Be_Taken,Action_Taken,Next_Date,[Medium],Delete_Status
    from Tbl_FollowUpLead_detail
    where Candidate_Id in (@candidateID)
    group by Counselor_Employee,Candidate_Id,Followup_Date,Followup_time,Remarks,Respond_Type,
        Action_to_Be_Taken,Action_Taken,Next_Date,[Medium],Delete_Status
    having count(distinct Follow_Up_Detail_Id)>1
open a

fetch a into @firstLogID,@duplicateCnt,
    @Counselor_Employee,@Candidate_Id,@Followup_Date,@Followup_time,
    @Remarks,@Respond_Type,
    @Action_to_Be_Taken,@Action_Taken,
    @Next_Date,@Medium,@Delete_Status
while @@FETCH_STATUS=0
begin
    insert into Tbl_FollowUpLead_xdup(candidateID,followupDetailID,duplicateCnt)
    select @candidateID candidateID,@firstLogID fl,@duplicateCnt-1 cnt

    --select * from Tbl_FollowUpLead_detail
    delete Tbl_FollowUpLead_detail
    where Counselor_Employee=@Counselor_Employee and Candidate_Id=@Candidate_Id and Followup_Date=@Followup_Date and Followup_time=@Followup_time
        and Remarks=@Remarks and isnull(Respond_Type,'''')=isnull(@Respond_Type,'''')
        and Action_to_Be_Taken=@Action_to_Be_Taken and Action_Taken=@Action_Taken
        and Next_Date=@Next_Date and [Medium]=@Medium and Delete_Status=@Delete_Status
        and Follow_Up_Detail_Id<>@firstLogID


    fetch a into @firstLogID,@duplicateCnt,
        @Counselor_Employee,@Candidate_Id,@Followup_Date,@Followup_time,
        @Remarks,@Respond_Type,
        @Action_to_Be_Taken,@Action_Taken,
        @Next_Date,@Medium,@Delete_Status
end
close a
deallocate a

END
    ')
END
