IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Role_by_name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Role_by_name]   

AS  
BEGIN
select * from dbo.tbl_Role
where role_Name=''student''
END
');
END;