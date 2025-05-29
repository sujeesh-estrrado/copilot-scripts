IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_MapUsertable_WithEmoployee_migration]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
CREATE procedure [dbo].[sp_MapUsertable_WithEmoployee_migration](@id bigint,@Employeeid bigint)
as
begin
if not exists(select * from Tbl_User where user_Id=@id)
begin
insert into Tbl_User(user_Id,role_Id,user_Status,user_DeleteStatus) values(@id,2,1,0);

end
if not exists (select * from Tbl_Employee_User where Employee_Id=@Employeeid)
begin

insert into Tbl_Employee_User(User_Id,Employee_Id)values(@id,@Employeeid);
end
end
  ')
END;
