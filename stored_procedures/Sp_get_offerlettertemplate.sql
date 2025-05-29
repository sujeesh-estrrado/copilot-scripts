IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_offerlettertemplate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_get_offerlettertemplate]
(
@flag int=0,
@Type varchar(100)='''',
@Level varchar(10)='''',
@OfferLetterType varchar(100)=''''
)
as
begin
select TG.Template_id,TG.Template_name,Html_Url from Tbl_Template_generation TG 
inner join Tbl_Template_Mapping TM on TM.Template_id=TG.Template_id 
where TM.Category=''Offer letter'' and TG.delete_status=0 and TM.delete_status=0;
end
')
END
