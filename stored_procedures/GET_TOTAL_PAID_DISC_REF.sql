IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GET_TOTAL_PAID_DISC_REF]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[GET_TOTAL_PAID_DISC_REF] --157,2,''''125''''

(@Candidate_Id bigint,@FeeHeadId bigint,@Itemdesc varchar(50))

as begin


select isnull(sum(Discount),0) as TotalDiscount,isnull(sum(Refund),0) as TotalRefund  from dbo.Tbl_Fee_Entry FE
inner join dbo.Tbl_Fee_Entry_Main FM on FM.Feeid=FE.Feeid and FM.FeeHeadId=FE.FeeHeadId
and FE.Amount=FM.Amount
where FE.Candidate_Id=@Candidate_Id and FE.FeeHeadId=@FeeHeadId
and FM.ItemDescription=@Itemdesc and FM.ActiveStatus is null


end

--sum(FE.Discount)

   ')
END;
