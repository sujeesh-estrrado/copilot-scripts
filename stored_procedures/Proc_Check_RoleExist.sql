IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Check_RoleExist]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Check_RoleExist] (@role_Name varchar(50))

AS

BEGIN
select role_Id from tbl_Role where role_Name=@role_Name
END
    ')
END
