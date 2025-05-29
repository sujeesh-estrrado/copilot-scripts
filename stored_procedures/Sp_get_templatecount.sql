IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_templatecount]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_get_templatecount] --''''
(  @SearchKeyWord varchar(max) )
as
begin
    select distinct count(*) as count
FROM           
                         dbo.Tbl_Template_generation 
                         where Tbl_Template_generation.delete_status=''False''  and (Tbl_Template_generation.Template_id like ''%'' +@SearchKeyWord+ ''%'' or Tbl_Template_generation.Template_name like ''%'' +@SearchKeyWord+ ''%''  or
                         Tbl_Template_generation.created_date like ''%'' +@SearchKeyWord+ ''%'' or Tbl_Template_generation.Created_by like ''%'' +@SearchKeyWord+ ''%'')
                         end
    ');
END;
