IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CheckTempName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_CheckTempName](@tempname varchar(500))
as
begin
select * from Tbl_Template_generation where Template_name=@tempname and delete_status=0;
end
    ')
END
