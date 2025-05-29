IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Visa_Appln]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Visa_Appln]
@Candidate_Id bigint,
@Applied_Date date,
@Remark varchar(500)
as
begin
update Tbl_Visa_ISSO set Expiry_Status=1 where Candidate_Id=@Candidate_Id
insert into Tbl_Visa_ISSO (Candidate_Id,Visa_Status,Expiry_Status,Applied_Date,Del_Status,Remark) values(@Candidate_Id,''Applied'',0,@Applied_Date,0,@Remark)
update tbl_visa_renewal set Del_Status=1 where Candidate_Id=@Candidate_Id
end
    ');
END;
