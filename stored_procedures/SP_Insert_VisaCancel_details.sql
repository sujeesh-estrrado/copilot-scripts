IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_VisaCancel_details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_VisaCancel_details](@Candidate_Id bigint)
as
begin
if not exists(select * from tbl_visa_details where candidate_id=@Candidate_Id)
begin 

insert into tbl_visa_details(Candidate_id,createdate,delete_status,Visa_RejectStatus)
 values(@Candidate_Id,getdate(),0,1)
 --update Tbl_Candidate_Personal_Det set visa=@visa,visafrom=@Visafrom,visato=@Visato where candidate_id=@Candidate_Id

end
ELSE
BEGIN 
UPDATE tbl_visa_details set Visa_RejectStatus=1 where Candidate_id=@Candidate_Id
update Tbl_Candidate_Personal_Det set visa=NULL,visafrom=NULL,visato=NULL where candidate_id=@Candidate_Id 
END
end
    ')
END;
