IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_VisaDetails_Student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Insert_VisaDetails_Student]
@Candidate_Id bigint,
@Applied_Date date,
@Remarks varchar(500)='''',
@flag int=0
as
begin
if(@flag=0)
begin
insert into Tbl_Visa_Renewal(Candidate_Id,Registrar_Approval,Finance_Approval,Applied_Date,Del_Status,Remark) values(@Candidate_Id,0,0,@Applied_Date,0,@Remarks)

insert into Approval_Request values(10,@Candidate_Id,@Applied_Date,1,null,null,null,null,0,null)

insert into Tbl_Student_Tc_request values(@Candidate_Id,''Visa'',@Remarks,1,null,''Pending'',null,null,GETDATE(),0,null,null,null,null)
end
if(@flag=1)
begin
update Tbl_Visa_Renewal set Finance_Approval=0 where @Candidate_Id=@Candidate_Id and Del_Status=0
insert into Approval_Request values(10,@Candidate_Id,getdate(),1,null,null,null,null,0,null)
end
if(@flag=2)
begin
update Tbl_Visa_Renewal set Registrar_Approval=0 where @Candidate_Id=@Candidate_Id and Del_Status=0
insert into Tbl_Student_Tc_request values(@Candidate_Id,''Visa'',@Remarks,1,null,''Pending'',null,null,GETDATE(),0,null,null,null,null)
end
end
    ');
END;
