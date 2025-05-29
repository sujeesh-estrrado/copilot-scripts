IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertOfferletterDetails_Conditional]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_InsertOfferletterDetails_Conditional](@candidate_id bigint=0,@user bigint=0,@path varchar(max)='''',  
@type varchar(max)='''',@Conditional_offerletter bit=0,@Resend_offerletter bit=0,@template_id bigint=0)      
as      
begin       
if not exists (select * from Tbl_Offerlettre where candidate_id=@candidate_id and Offerletter_Path=@path)      
begin      
insert into Tbl_Offerlettre(candidate_id,Sented_by,Sentdate,Offerletter_Path,created_date,delete_status,Offerletter_type,Conditional_offerletter,Resend_offerletter,Template_id)   
values(@candidate_id,@user,getdate(),@path,GETDATE(),0,@type,@Conditional_offerletter,@Resend_offerletter,@template_id);   
insert into Tbl_offerletter_log (candidateid,tempname,temppath,senddate,sendby,template_id)values (@candidate_id,'''',@path,GETDATE(),@user, @template_id)
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)      
begin      
insert into tbl_approval_log(candidate_id,Offerletter_sent,delete_status) values(@candidate_id,1,0)      
end       
else       
begin      
update tbl_approval_log set Offerletter_sent=1, Offerletter_status =null where candidate_id=@candidate_id;      
end      
END      
else      
begin      
update Tbl_Offerlettre set  Sented_by=@user,delete_status=0,created_date=GETDATE(),Offerletter_type=@type,Conditional_offerletter=@Conditional_offerletter,Resend_offerletter=@Resend_offerletter,Template_id = @template_id  
where candidate_id=@candidate_id and Offerletter_Path=@path      
update tbl_approval_log set Offerletter_status =null,Offerletter_sent=1 where candidate_id=@candidate_id;      
end      
end     ');
END;
