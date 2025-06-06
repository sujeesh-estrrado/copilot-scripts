IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_UpdateOfferletterDetails_Conditional]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Sp_UpdateOfferletterDetails_Conditional]
(@candidate_id bigint=0,@user bigint=0,@path varchar(max)='''',  
@type varchar(max)='''',@Conditional_offerletter bit=0,@Resend_offerletter bit=0,@template_id bigint=0)  
as
begin
        update Tbl_Offerlettre set  Sented_by=@user,delete_status=0,created_date=GETDATE(),Offerletter_type=@type,Conditional_offerletter=@Conditional_offerletter,Resend_offerletter=@Resend_offerletter,Offerletter_Path=@path,Template_id = @template_id
where candidate_id=@candidate_id --and Offerletter_Path=@path 
insert into Tbl_offerletter_log (candidateid,tempname,temppath,senddate,sendby,template_id)values (@candidate_id,'''',@path,GETDATE(),@user, @template_id)
UPDATE Tbl_offerletter_log
SET status = ''Reverted''
WHERE status IS NULL AND id < (SELECT MAX(id) FROM Tbl_offerletter_log) and candidateid =@candidate_id
update tbl_approval_log set Offerletter_status=0 ,Offerletter_sent=1 where candidate_id=@candidate_id;

end
    ')
END;
