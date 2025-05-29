IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Remark_Settings]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Remark_Settings]
@flag bigint=0,
@id bigint=0,
@status bigint=0
as
begin
if(@flag=0)
begin
select * from tbl_remark_settings
end
if(@flag=2)
begin
update tbl_remark_settings set Status=@status where Remark_Id=@id

select * from tbl_remark_settings where Remark_Id=@id
end
end
    ')
END;
