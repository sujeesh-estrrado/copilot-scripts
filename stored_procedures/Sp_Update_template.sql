IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_template]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Update_template](
@Updatedate date,
@code varchar(max),
@id bigint,
@TemplateName varchar(50)='''',
@Type varchar(10)='''',
@Level varchar(10)='''',
@OfferLetterType varchar(10)='''',
@Fname varchar(10)=''''
)
as
begin
update Tbl_Template_generation set code=@code,updated_date=@Updatedate,Template_name=@TemplateName where Template_id=@id;

end
    ')
END;
