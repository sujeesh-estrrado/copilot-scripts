IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Visa_Approval_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Visa_Approval_Status]
@Candidate_Id bigint,
@Visa_Status varchar(50),
@Visa_Type varchar(50)=null,
@visa_expiry date=null,
@duration bigint=0,
@rejection_remark varchar(200)=null,
@flag bigint=0,
@visa_id bigint
as
begin
if(@flag=0)
begin
update Tbl_Visa_ISSO set Expiry_Status=1 ,Del_Status=1 where Candidate_Id=@Candidate_Id and Visa_Status=''Approved''
update Tbl_Visa_ISSO set Visa_Type=@Visa_Type,Visa_Expiry=@visa_expiry,Duration=@duration,Visa_Status=@Visa_Status where Candidate_Id=@Candidate_Id and Visa_Id=@visa_id
--insert into Tbl_Visa_ISSO (Candidate_Id,Visa_Type,Visa_Expiry,Duration,Visa_Status) values(@Candidate_Id,@Visa_Type,@visa_expiry,@duration,@Visa_Status)
end
 if(@flag=1)
begin
update Tbl_Visa_ISSO set Expiry_Status=1,  Visa_Status=@Visa_Status , Reject_Remark=@rejection_remark where Candidate_Id=@Candidate_Id and Visa_Id=@visa_id
--insert into Tbl_Visa_ISSO(Candidate_Id,Visa_Type,Expiry_Status,Reject_Remark) values(@Candidate_Id,@Visa_Type,1,@rejection_remark)
end
end
    ');
END;
