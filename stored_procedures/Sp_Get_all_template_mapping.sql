IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_template_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Get_all_template_mapping]
as
begin
SELECT        dbo.Tbl_Template_Mapping.Category, dbo.Tbl_Template_generation.Template_name, dbo.Tbl_Template_Mapping.Create_date, dbo.Tbl_Template_Mapping.Template_mapping_id
FROM            dbo.Tbl_Template_generation INNER JOIN
                         dbo.Tbl_Template_Mapping ON dbo.Tbl_Template_generation.Template_id = dbo.Tbl_Template_Mapping.Template_id where dbo.Tbl_Template_generation.delete_status=0; 
                                         end
    ')
END
