IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_User_by_Role_id]')
    AND type = N'P'
)
BEGIN
    EXEC('
      create procedure [dbo].[Sp_Get_User_by_Role_id]
(@roleid bigint)
as
begin
select * from Tbl_User where role_Id=@roleid;
end

    ')
END
GO