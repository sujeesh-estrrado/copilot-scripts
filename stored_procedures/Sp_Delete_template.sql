IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Delete_template] (@id bigint)
as
begin
if not exists(select * from Tbl_Template_Mapping where Template_id=@id)
begin
update Tbl_Template_generation set delete_status=''true'' where Template_id=@id;
end 
--else
--begin
--update Tbl_Template_generation set delete_status=''true'' where Template_id=@id;
--delete from Tbl_Template_Mapping where Template_id=@id;
--end
end
    ')
END
