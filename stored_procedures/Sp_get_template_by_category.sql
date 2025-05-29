IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_template_by_category]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_get_template_by_category](@tempcategory varchar(max))
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    

    -- Insert statements for procedure here
    SELECT        dbo.Tbl_Template_Mapping.Category, dbo.Tbl_Template_generation.Template_name, dbo.Tbl_Template_Mapping.Create_date, dbo.Tbl_Template_Mapping.Template_mapping_id, dbo.Tbl_Template_generation.Html_Url, 
                         dbo.Tbl_Template_generation.delete_status
FROM            dbo.Tbl_Template_generation INNER JOIN
                         dbo.Tbl_Template_Mapping ON dbo.Tbl_Template_generation.Template_id = dbo.Tbl_Template_Mapping.Template_id
                         where   dbo.Tbl_Template_Mapping.Category=@tempcategory and dbo.Tbl_Template_generation.delete_status=0 ;
END

    ');
END;
