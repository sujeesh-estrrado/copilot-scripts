IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_DISCOUNT_APPROVAL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERT_DISCOUNT_APPROVAL]

(@Candidate_Id bigint,@ItemDesc varchar(100),@FeeHeadId bigint,@Remarks varchar(100),
@DiscAmount decimal(18,2),@Status bit,@PriorityStatus bit,@AuthorityUserId bigint,@FinalStat bit)

as begin

insert into dbo.Tbl_Discount_Approval(Candidate_Id,ItemDesc,FeeHeadId,Remarks,
DiscountAmount,Status,PriorityStatus,AuthorityUserId,FinalStatus)
values
(@Candidate_Id,@ItemDesc,@FeeHeadId,@Remarks,
@DiscAmount,@Status,@PriorityStatus,@AuthorityUserId,@FinalStat)

select scope_identity()
end


   ')
END;
