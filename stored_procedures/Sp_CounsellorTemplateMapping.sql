IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CounsellorTemplateMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_CounsellorTemplateMapping]
@templateid bigint,
@CounsellorId bigint
as
 begin 
 
 insert into CounsellorTemplateMapping(CounsellorId,TemplateId,DelStatus,Counsellor) 
 values(@CounsellorId,@templateid,0,'''')
 end
    ')
END
