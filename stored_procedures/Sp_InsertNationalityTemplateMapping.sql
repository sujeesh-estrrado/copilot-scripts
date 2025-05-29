IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertNationalityTemplateMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_InsertNationalityTemplateMapping]
@templateid bigint,
@countryid bigint
as
 begin 
 
 insert into NationalityTemplateMapping(NationalityId,TemplateId,DelStatus,Nationality) 
 values(@countryid,@templateid,0,'''')
 end

    ');
END;
