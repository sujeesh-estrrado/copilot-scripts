IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertInterestlevelTemplateMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_InsertInterestlevelTemplateMapping]
@templateid bigint,
@InterestLevel varchar(100)
as
 begin 
 
 insert into InterestlevelTemplateMapping(Interestlevel,TemplateId,DelStatus) 
 values(@InterestLevel,@templateid,0)
 end')
END
