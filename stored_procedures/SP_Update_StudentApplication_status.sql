IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_StudentApplication_status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_StudentApplication_status](@candidate_id bigint,@status varchar(50),@Uid bigint,@flag bigint)      
as      
begin      
if @flag=1      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status,Editable=0 where Candidate_Id=@candidate_id;     
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)    
begin    
insert into tbl_approval_log(candidate_id,Approved_by,Approved_date,Verified_date,Updated_date,delete_status) values(@candidate_id,@Uid,GETDATE(),GETDATE(),GETDATE(),0)      
end      
else    
begin     
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id  and delete_status=0    
    
    
end    
end    
else if @flag=2      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status,Editable=0 where Candidate_Id=@candidate_id;      
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id   and delete_status=0     
end      
else if @flag=3      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status,Editable=0 where Candidate_Id=@candidate_id;      
end      
else if @flag=4      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status where Candidate_Id=@candidate_id;      
end      
else if @flag=5      
begin      
if not exists(select * from Tbl_Student_NewApplication where Candidate_Id=@candidate_id)      
begin      
      
update tbl_candidate_personal_det set ApplicationStatus=@status,IDMatrixNo=null where Candidate_Id=@candidate_id;      
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)    
begin    
insert into tbl_approval_log(candidate_id,Approved_by,Approved_date,Verified_date,Updated_date,delete_status) values(@candidate_id,@Uid,GETDATE(),GETDATE(),GETDATE(),0)      
end      
else    
begin     
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id  and delete_status=0    
    
    
end    
      
end      
else      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status,IDMatrixNo=null where Candidate_Id=@candidate_id and candidate_delstatus=0      
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)    
begin    
insert into tbl_approval_log(candidate_id,Approved_by,Approved_date,Verified_date,Updated_date,delete_status) values(@candidate_id,@Uid,GETDATE(),GETDATE(),GETDATE(),0)      
end      
else    
begin     
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id  and delete_status=0    
    
    
end    
end      
end      
else if @flag=6     
begin      
if not exists(select * from Tbl_Student_NewApplication where Candidate_Id=@candidate_id)      
begin      
      
update tbl_candidate_personal_det set ApplicationStatus=@status where Candidate_Id=@candidate_id;      
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)    
begin    
insert into tbl_approval_log(candidate_id,Approved_by,Approved_date,Verified_date,Updated_date,delete_status) values(@candidate_id,@Uid,GETDATE(),GETDATE(),GETDATE(),0)      
end      
else    
begin     
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id  and delete_status=0    
    
    
end    
      
end      
else      
begin      
update Tbl_Student_NewApplication set ApplicationStatus=@status where Candidate_Id=@candidate_id and candidate_delstatus=0      
if not exists (select * from tbl_approval_log where candidate_id=@candidate_id and delete_status=0)    
begin    
insert into tbl_approval_log(candidate_id,Approved_by,Approved_date,Verified_date,Updated_date,delete_status) values(@candidate_id,@Uid,GETDATE(),GETDATE(),GETDATE(),0)      
end      
else    
begin     
update tbl_approval_log set Verified_by=@Uid,Verified_date=getdate(),Updated_date=getdate() where candidate_id=@candidate_id  and delete_status=0    
    
    
end    
end      
end  
else if @flag=7      
begin      
    update Tbl_User set role_Id=4 where user_Id=(select user_Id from Tbl_Student_User where Candidate_Id=@candidate_id);
end  
end   
    ')
END
