IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_insert_template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_insert_template]
(
@templatename varchar(500),
@file varchar(500),
@createdate date,
@createby bigint,
@status bit,
@code varchar(max),
@Type varchar(50)='''',
@Level varchar(50)='''',
@OfferLetterType varchar(50)=''''



)
as
begin
if not exists (select * from Tbl_Template_generation where Template_name=@templatename)
begin
insert into Tbl_Template_generation(Template_name,Html_Url,Created_by,created_date,active,code,delete_status)
values (@templatename,@file,@createby,@createdate,@status,@code,0);
end
else
begin
update Tbl_Template_generation set updated_date=@createdate,code=@code,delete_status=0 where Template_name=@templatename;
end
end
    ');
END;
