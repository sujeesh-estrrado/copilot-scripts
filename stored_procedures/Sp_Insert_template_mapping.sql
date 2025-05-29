IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_template_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_template_mapping](@tempid bigint,@tempcategory varchar(max))
as
begin
if not exists(select * from Tbl_Template_Mapping where Template_id=@tempid and Category=@tempcategory and delete_status=0)
begin
insert into Tbl_Template_Mapping(Template_id,Category,Create_date,delete_status) values(@tempid,@tempcategory,GETDATE(),0);
end
end
    ');
END;
