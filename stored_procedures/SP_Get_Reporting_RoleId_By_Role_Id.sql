IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Reporting_RoleId_By_Role_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Reporting_RoleId_By_Role_Id]

(@role_Id bigint)

AS

BEGIN

SELECT reporting_role_Id

FROM dbo.Tbl_Role_hierarchy

WHERE role_Id=@role_Id

END');
END;
