IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Delete_template_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Sp_Delete_template_mapping]
    @id bigint
AS
BEGIN
    delete from Tbl_Template_Mapping where Template_mapping_id=@id
END
    ')
END
