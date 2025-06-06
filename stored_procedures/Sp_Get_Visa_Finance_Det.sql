IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Visa_Finance_Det]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_Visa_Finance_Det]
@candidate_Id bigint
as
begin
select CONVERT(varchar(10),Applied_Date,20) as Applied_Date,Remark,Case when AR.ApprovalStatus=1 then ''Pending'' end as pendingstatus from Tbl_Visa_Renewal VI Left join Approval_Request AR on VI.Candidate_Id=AR.StudentId  where Candidate_Id=@candidate_Id and AR.ApprovalStatus=1 and VI.Del_Status=0 order by Applied_Date desc
end
    ')
END
