IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_MapUsertable_WithStudent_migration]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
CREATE procedure [dbo].[sp_MapUsertable_WithStudent_migration](@id bigint,@studentid bigint)
as
begin
if not exists(select * from Tbl_User where user_Id=@id)
begin
insert into Tbl_User(user_Id,role_Id,user_Status,user_DeleteStatus) values(@id,5,1,0);

end
if not exists (select * from Tbl_Student_User where Candidate_Id=@studentid)
begin

insert into Tbl_Student_User(User_Id,Candidate_Id)values(@id,@studentid);
end
end
  ')
END;
